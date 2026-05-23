import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';

class PayoutsScreen extends StatelessWidget {
  const PayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // ── Full-bleed primary gradient hero ──────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4544F4), Color(0xFF3332D4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: topPadding + 8),

                // Back arrow + title row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Available balance in Escrow',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      // balance icon button for spacing symmetry
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Big balance
                Text(
                  Formatters.formatCurrency(MockData.availableBalance),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                // Auto-transfer subtitle
                Text(
                  'Auto-transfer to Zenith Bank · in 3 days',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 24),

                // Two sub-cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HeroSubCard(
                          label: 'This Month',
                          value: Formatters.formatCurrency(MockData.thisMonthPayout),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroSubCard(
                          label: 'Available for Payout',
                          value: Formatters.formatCurrency(MockData.availableForPayout),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // White rounded top corners transition
                Container(
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                ),
              ],
            ),
          ),

          // ── White body ────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Upcoming payout banner
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Upcoming Payout - '),
                                    TextSpan(
                                      text: '₦430,000',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'on 30th May, 2026 you will receive ₦430,000 to 12****2323',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Recent payouts',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Payouts list
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: MockData.recentPayouts.asMap().entries.map((entry) {
                      final i = entry.key;
                      final payout = entry.value;
                      final isPending = payout.status == 'PENDING';

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left: title + subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _payoutTitle(payout.description),
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      isPending
                                          ? Text(
                                              'Processing · Est. today',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: AppColors.pendingText,
                                              ),
                                            )
                                          : Text(
                                              '${Formatters.formatDate(payout.createdAt)} · ${payout.bankName}',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Right: amount
                                Text(
                                  isPending
                                      ? Formatters.formatCurrency(payout.amount)
                                      : '+${Formatters.formatCurrency(payout.amount)}',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _amountColor(payout.status),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < MockData.recentPayouts.length - 1)
                            const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.divider,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Extracts a human-friendly title from the payout description.
  /// e.g. "Payout for booking #bk-005 (Traditional Wedding cake)" -> "Wedding cake — Amaka O."
  /// Falls back to the raw description if no pattern is matched.
  String _payoutTitle(String description) {
    // Map descriptions to friendly titles
    if (description.contains('bk-005')) return 'Wedding cake — Chisom I.';
    if (description.contains('bk-006')) return 'Gender Reveal Cake — Sola A.';
    if (description.contains('Pending payout')) return '3 completed orders (Apr–May)';
    if (description.contains('Failed')) return 'Failed — bank details mismatch';
    if (description.contains('March')) return 'March bookings batch';
    return description;
  }

  Color _amountColor(String status) {
    switch (status) {
      case 'PAID':
        return AppColors.activeText;
      case 'PENDING':
        return AppColors.pendingText;
      case 'FAILED':
        return AppColors.cancelledText;
      default:
        return AppColors.activeText;
    }
  }
}

// ── Hero sub-card ─────────────────────────────────────────────────────────────
class _HeroSubCard extends StatelessWidget {
  final String label;
  final String value;

  const _HeroSubCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
