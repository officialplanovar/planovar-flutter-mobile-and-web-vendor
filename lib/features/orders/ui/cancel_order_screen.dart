import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/models/order_model.dart';
import '../bloc/orders_cubit.dart';

class CancelOrderScreen extends StatefulWidget {
  final String orderId;

  const CancelOrderScreen({super.key, required this.orderId});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  int? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  static const _reasons = [
    'Client was rude',
    'Event was more than described',
    'The Client was late to the event',
    'Client Refused to Pay the second installment',
    'Other issue',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  OrderModel? _orderFrom(List<OrderModel> orders) {
    for (final o in orders) {
      if (o.id == widget.orderId) return o;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersCubit>().state.orders;
    final order = _orderFrom(orders);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: context.c.divider),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: context.c.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cancel Booking',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            if (order != null)
              Text(
                '${order.orderNumber} · ${order.clientName}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: context.c.textSecondary,
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Notice Banner ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.c.primaryLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Our team mediates all disputes. We aim to resolve within 48 hours. '
                      'Try messaging the client first — most issues are resolved quickly.',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Reasons Section ────────────────────────────────────────
            const SizedBox(height: 24),
            Text(
              'Reason for Cancelling Booking',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(_reasons.length, (i) {
              final selected = _selectedReason == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedReason = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : context.c.border,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _reasons[i],
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? AppColors.primary
                          : context.c.textPrimary,
                    ),
                  ),
                ),
              );
            }),

            // ── Describe the Issue ─────────────────────────────────────
            const SizedBox(height: 24),
            Text(
              'Describe the issue',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              minLines: 5,
              maxLines: 10,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: context.c.surfaceElevated,
                hintText:
                    'Describe what happened in detail, include dates, amounts, and any relevant context',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: context.c.textHint,
                  height: 1.5,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),

            // ── Attach Evidence ────────────────────────────────────────
            const SizedBox(height: 24),
            Text(
              'Attach evidence (optional)',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Image picker would go here
              },
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  borderRadius: 14,
                  dashWidth: 8,
                  dashSpace: 5,
                ),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppIcon('photo',
                            size: 28, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Image',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Bar ─────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.c.surface,
          border: Border(top: BorderSide(color: context.c.divider)),
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cancel Order — red gradient
            GestureDetector(
              onTap: () async {
                final reason = _selectedReason != null
                    ? _reasons[_selectedReason!]
                    : null;
                final note = _descriptionController.text.trim();
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                try {
                  await context.read<OrdersCubit>().reject(
                        widget.orderId,
                        reason: [reason, if (note.isNotEmpty) note]
                            .whereType<String>()
                            .join(' — '),
                      );
                  navigator.pop();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancelled'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceFirst('Exception: ', '')),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'Cancel Order',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Message Client Instead — outlined
            GestureDetector(
              onTap: () => context.go(AppRoutes.messages),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: AppColors.primary, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'Message Client Instead',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dashed Border Painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashSpace != dashSpace;
}
