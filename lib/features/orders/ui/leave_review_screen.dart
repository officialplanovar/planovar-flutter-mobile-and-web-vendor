import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../bloc/orders_cubit.dart';

class LeaveReviewScreen extends StatefulWidget {
  final String orderId;

  const LeaveReviewScreen({super.key, required this.orderId});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  int _rating = 4;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
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
    final clientName = order?.clientName ?? 'Client';
    final clientImage = order?.clientImage;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Review',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Let us know how your experience was with $clientName',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),

            // ── Client Avatar ──────────────────────────────────────────
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: context.c.divider,
                child: ClipOval(
                  child: AppNetworkImage(
                    url: clientImage,
                    width: 104,
                    height: 104,
                    fit: BoxFit.cover,
                    errorWidget: Center(
                      child: Text(
                        clientName.isNotEmpty ? clientName[0] : '?',
                        style: GoogleFonts.urbanist(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: context.c.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Client Name ────────────────────────────────────────────
            Text(
              clientName,
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // ── Star Rating Row ────────────────────────────────────────
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        Icons.star_rounded,
                        size: 44,
                        color: filled
                            ? AppColors.starColor
                            : context.c.border,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // ── Feedback Label ─────────────────────────────────────────
            Text(
              'Leave a Detailed feedback',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // ── Feedback TextField ─────────────────────────────────────
            TextField(
              controller: _feedbackController,
              minLines: 5,
              maxLines: 10,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: context.c.surface,
                hintText: 'Let us know how your experience was',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: context.c.textHint,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: context.c.border, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: context.c.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),

      // ── Bottom Button ───────────────────────────────────────────────────
      bottomNavigationBar: Container(
        color: context.c.surface,
        padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottomInset),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Review submitted!',
                  style:
                      GoogleFonts.urbanist(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B6AF7), Color(0xFF3332D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                'Send Review',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
