import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';

/// Language preference. English is fully available today; other languages are
/// listed so vendors can register interest, and the choice is persisted for
/// when full translations ship (app-wide i18n is a separate, phased effort).
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _prefsKey = 'preferred_language';

  // (code, label, available-now)
  static const _languages = [
    ('en', 'English', true),
    ('pcm', 'Nigerian Pidgin', false),
    ('ha', 'Hausa', false),
    ('yo', 'Yoruba', false),
    ('ig', 'Igbo', false),
    ('fr', 'Français', false),
  ];

  String _selected = 'en';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => _selected = p.getString(_prefsKey) ?? 'en');
    });
  }

  Future<void> _select(String code, bool available) async {
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That language is coming soon.')),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
    if (mounted) setState(() => _selected = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.c.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Language',
            style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Planovar is currently available in English. More languages are on '
            'the way — pick one to register your interest.',
            style: GoogleFonts.urbanist(
                fontSize: 13, color: context.c.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          for (final (code, label, available) in _languages)
            _row(context, code, label, available),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String code, String label, bool available) {
    final selected = _selected == code;
    return GestureDetector(
      onTap: () => _select(code, available),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? AppColors.primary : context.c.border,
              width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: available
                          ? context.c.textPrimary
                          : context.c.textHint)),
            ),
            if (!available)
              Text('Soon',
                  style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.c.textHint))
            else if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
