import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/app_button.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final String conversationId;
  const CreateInvoiceScreen({super.key, required this.conversationId});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _InvoiceLineItem {
  final TextEditingController desc;
  final TextEditingController amount;

  _InvoiceLineItem({String descText = '', String amountText = ''})
      : desc = TextEditingController(text: descText),
        amount = TextEditingController(text: amountText);

  void dispose() {
    desc.dispose();
    amount.dispose();
  }
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  ConversationModel? _conv;
  late final List<_InvoiceLineItem> _items;

  @override
  void initState() {
    super.initState();
    if (widget.conversationId.isNotEmpty) {
      MessagingService().getConversations().then((list) {
        if (!mounted) return;
        final match = list.where((c) => c.id == widget.conversationId);
        if (match.isNotEmpty) setState(() => _conv = match.first);
      }).catchError((_) {});
    }
    _items = [
      _InvoiceLineItem(descText: '', amountText: ''),
    ];
    for (final item in _items) {
      item.amount.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  int get _subtotal {
    int total = 0;
    for (final item in _items) {
      total += int.tryParse(item.amount.text.replaceAll(',', '')) ?? 0;
    }
    return total;
  }

  void _addItem() {
    final newItem = _InvoiceLineItem();
    newItem.amount.addListener(() => setState(() {}));
    setState(() => _items.add(newItem));
  }

  void _removeItem(int index) {
    final removed = _items.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  String _formattedEventDate() {
    if (_conv?.eventDate == null) return '';
    return Formatters.formatDate(_conv!.eventDate!);
  }

  Widget _buildGradientAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Create invoice',
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF666666),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'From QT-2026-047',
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${_conv?.participantName ?? 'Client'} · ${_conv?.eventName ?? 'Event'} · ${_formattedEventDate()}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? rightLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
          ),
        ),
        if (rightLabel != null)
          Text(
            rightLabel,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.c.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: context.c.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLineItemRow(int index) {
    final item = _items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: item.desc,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textHint,
                ),
                filled: true,
                fillColor: context.c.surfaceElevated,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: item.amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textHint,
                ),
                filled: true,
                fillColor: context.c.surfaceElevated,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.error,
            onPressed: () => _removeItem(index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemButton() {
    return GestureDetector(
      onTap: _addItem,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: 0.5),
          radius: 24,
        ),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(
            '+ Add Item',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard({
    required int milestoneNumber,
    required int amount,
    required String dueLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border.all(color: context.c.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milestone $milestoneNumber',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 60,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.c.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '50',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.c.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '%',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                Formatters.formatCurrency(amount),
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dueLabel,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: context.c.textSecondary,
                  ),
                ),
              ),
              Text(
                Formatters.formatCurrency(amount),
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: _buildGradientAppBar() as PreferredSizeWidget,
      body: SingleChildScrollView(
        padding: pagePadding(context, base: 20)
            .add(const EdgeInsets.only(top: 24, bottom: 140)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Green info banner
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                border: Border.all(color: const Color(0xFF27AE60)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      color: Color(0xFF27AE60), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pre-filled from accepted quote QT-2026-047. Review items and payment milestones, then send to confirm the booking.',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Invoice ref + Issue date
            Row(
              children: [
                Expanded(child: _buildReadOnlyField('INV-2026-047')),
                const SizedBox(width: 12),
                Expanded(child: _buildReadOnlyField('18-09-2026')),
              ],
            ),
            const SizedBox(height: 28),

            // Invoice Items
            _buildSectionTitle('Invoice Items'),
            const SizedBox(height: 12),
            ...List.generate(_items.length, (i) => _buildLineItemRow(i)),
            const SizedBox(height: 8),
            _buildAddItemButton(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Subtotal ${Formatters.formatCurrency(_subtotal)}',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.c.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Payment Milestones
            _buildSectionTitle('Payment Milestones', rightLabel: 'From Quote'),
            const SizedBox(height: 12),
            _buildMilestoneCard(
              milestoneNumber: 1,
              amount: 150000,
              dueLabel: 'Due on booking confirmation (immediately)',
            ),
            _buildMilestoneCard(
              milestoneNumber: 2,
              amount: 150000,
              dueLabel: '23rd May 2026',
            ),
            const SizedBox(height: 28),

            // Payout to your account
            Text(
              'Payout to your account',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Man power',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textSecondary,
                  ),
                ),
                Text(
                  'Zenith Bank',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.c.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textSecondary,
                  ),
                ),
                Text(
                  '··· ··· 4521',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.c.textPrimary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: context.c.border, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your payout',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textSecondary,
                  ),
                ),
                Text(
                  '₦215,600',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: pagePadding(context, base: 20).add(EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        )),
        decoration: BoxDecoration(
          color: context.c.surface,
          border: Border(
            top: BorderSide(color: context.c.border),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(
              'Send Invoice to ${_conv?.participantName ?? 'Client'}',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invoice sent successfully!')),
                );
              },
              icon: const Icon(Icons.send_rounded),
              iconTrailing: false,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: context.c.primaryLight,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove_red_eye_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Preview',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashed border painter for "+ Add Item" button
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    this.radius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
