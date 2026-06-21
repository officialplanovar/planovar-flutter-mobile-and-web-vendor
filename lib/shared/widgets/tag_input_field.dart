import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// A chip-based tag input.
///
/// - Press **comma** or **Enter** to commit the current text as a tag.
/// - Paste a comma-separated string to add multiple tags at once.
/// - Tap the **×** on a chip to remove it.
/// - Press **Backspace** on an empty field to remove the last tag.
/// - Duplicate (case-insensitive) and blank tags are silently ignored.
///
/// Tags feed directly into search & recommendation via [ListingModel.tags].
class TagInputField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final String label;
  final String hint;
  final int maxTags;

  const TagInputField({
    super.key,
    required this.tags,
    required this.onChanged,
    this.label = 'Tags',
    this.hint = 'e.g. Wedding, Cake, Luxury',
    this.maxTags = 20,
  });

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  void _commitText(String raw) {
    // Split on comma to support paste of "a, b, c"
    final parts = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    final current = List<String>.from(widget.tags);
    bool changed = false;
    for (final tag in parts) {
      if (current.length >= widget.maxTags) break;
      final exists = current.any((t) => t.toLowerCase() == tag.toLowerCase());
      if (!exists) {
        current.add(tag);
        changed = true;
      }
    }
    if (changed) widget.onChanged(current);
    _ctrl.clear();
  }

  void _removeTag(int index) {
    final updated = List<String>.from(widget.tags)..removeAt(index);
    widget.onChanged(updated);
  }

  void _removeLastTag() {
    if (_ctrl.text.isEmpty && widget.tags.isNotEmpty) {
      final updated = List<String>.from(widget.tags)..removeLast();
      widget.onChanged(updated);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final borderColor = _isFocused ? AppColors.primary : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),

        // Chip container
        GestureDetector(
          onTap: () => _focus.requestFocus(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: _isFocused ? 1.5 : 1,
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Existing tag chips
                ...widget.tags.asMap().entries.map((entry) {
                  return _TagChip(
                    label: entry.value,
                    onRemove: () => _removeTag(entry.key),
                  );
                }),

                // Text input
                if (widget.tags.length < widget.maxTags)
                  _InlineInput(
                    controller: _ctrl,
                    focusNode: _focus,
                    hint: widget.tags.isEmpty ? widget.hint : 'Add tag...',
                    onCommit: _commitText,
                    onBackspace: _removeLastTag,
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 6),
        Text(
          'Press comma or Enter to add a tag  ·  ${widget.tags.length}/${widget.maxTags}',
          style: GoogleFonts.urbanist(
            fontSize: 11,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _TagChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.close_rounded,
              size: 13,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Inline text input (sits inside the Wrap) ──────────────────────────────────

class _InlineInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onCommit;
  final VoidCallback onBackspace;

  const _InlineInput({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onCommit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.textHint,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            // Auto-commit when user types a comma
            if (value.endsWith(',')) {
              onCommit(value.replaceAll(',', '').trim());
            }
          },
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) onCommit(value.trim());
            focusNode.requestFocus();
          },
        ),
      ),
    );
  }
}
