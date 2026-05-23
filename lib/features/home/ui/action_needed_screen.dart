import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/quote_model.dart';

class ActionNeededScreen extends StatelessWidget {
  const ActionNeededScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quotes = MockData.pendingQuotes;
    final grouped = _groupByDay(quotes);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
            title: Text(
              'Action Needed',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: GoogleFonts.urbanist(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...entry.value.map(
                (quote) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ActionCard(quote: quote),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Groups quotes into "Today", "Yesterday", or "dd MMM" buckets.
  Map<String, List<QuoteModel>> _groupByDay(List<QuoteModel> quotes) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<QuoteModel>> result = {};

    for (final q in quotes) {
      final d = DateTime(q.createdAt.year, q.createdAt.month, q.createdAt.day);
      final String label;
      if (d == today) {
        label = 'Today';
      } else if (d == yesterday) {
        label = 'Yesterday';
      } else {
        label = Formatters.formatDate(q.createdAt);
      }
      result.putIfAbsent(label, () => []).add(q);
    }

    return result;
  }
}

// ── Action Card ────────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final QuoteModel quote;

  const _ActionCard({required this.quote});

  bool get _isOrder => quote.totalAmount > 0;

  @override
  Widget build(BuildContext context) {
    final accentColor = _isOrder ? AppColors.error : AppColors.primary;
    final icon = _isOrder ? Icons.inventory_2_outlined : Icons.chat_bubble_outline_rounded;
    final title = _isOrder ? 'New Order' : 'Quote request';
    final subtitle = _isOrder
        ? '${quote.clientName.split(' ').first} O. · ${Formatters.timeAgo(quote.createdAt)} · ${Formatters.formatCurrency(quote.totalAmount)}'
        : '${quote.clientName.split(' ').first} B. · ${quote.eventName.toLowerCase()}';
    final buttonLabel = _isOrder ? 'View Details' : 'Open & Respond';

    return Container(
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon box
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                subtitle,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // "New" badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'New',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Action button
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.orderDetailPath(quote.id)),
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            buttonLabel,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }
}
