import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _period = 'All time';
  String _chartPeriod = 'This week';

  @override
  Widget build(BuildContext context) {
    final analytics = MockData.analyticsData;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Analytics',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'track your earnings in one place',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Period + Export row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => _PeriodPicker(
                      current: _period,
                      onSelected: (p) => setState(() => _period = p),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _period,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.download_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Export',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary cards 2×2 grid
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  value: '₦430k',
                  label: 'Total Earnings',
                  badge: '18%',
                  badgePositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  value: '${analytics.totalOrders}',
                  label: 'Total Orders',
                  badge: '3',
                  badgePositive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  value: '1,204',
                  label: 'Profile Views',
                  badge: '8%',
                  badgePositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  value: '${(analytics.bookingRate * 100).toStringAsFixed(0)}%',
                  label: 'Booking Rate',
                  badge: '5%',
                  badgePositive: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Earnings chart card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Earnings',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📅', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              _chartPeriod,
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Chart with Y-axis labels
                SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Y-axis labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _YLabel('1M'),
                          _YLabel('200k'),
                          _YLabel('50k'),
                          _YLabel('10k'),
                          _YLabel('0'),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Bar chart
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            barGroups: analytics.weeklyEarnings.asMap().entries.map((e) {
                              final isHighest = e.key == 4;
                              return BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value / 1000,
                                    color: isHighest
                                        ? AppColors.primary
                                        : AppColors.primary.withValues(alpha: 0.55),
                                    width: 20,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (v, _) => Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][v.toInt()],
                                      style: GoogleFonts.urbanist(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: AppColors.border,
                                strokeWidth: 1,
                                dashArray: [4, 4],
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Top listings by views
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top listings by views',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _TopListingRow(title: '3-tier wedding cake', views: 243, maxViews: 243),
                const SizedBox(height: 14),
                _TopListingRow(title: 'Tasting session', views: 89, maxViews: 243),
                const SizedBox(height: 14),
                _TopListingRow(title: 'Gold cake stand', views: 41, maxViews: 243),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Performance card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _PerformanceRow(label: 'Avg. response time', value: '28 mins'),
                const Divider(height: 1, color: AppColors.divider),
                _PerformanceRow(label: 'Response rate', value: '94%'),
                const Divider(height: 1, color: AppColors.divider),
                _PerformanceRowStar(label: 'Average Rating', value: '4.9'),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Period picker bottom sheet ────────────────────────────────────────────────
class _PeriodPicker extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelected;

  const _PeriodPicker({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const periods = ['All time', 'This week', 'This month', 'This year'];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: periods
              .map(
                (p) => ListTile(
                  title: Text(
                    p,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: p == current ? FontWeight.w700 : FontWeight.w500,
                      color: p == current ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: p == current
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    onSelected(p);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ── Y-axis label ──────────────────────────────────────────────────────────────
class _YLabel extends StatelessWidget {
  final String text;
  const _YLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 10,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final String badge;
  final bool badgePositive;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.badge,
    required this.badgePositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgePositive ? AppColors.activeBg : AppColors.cancelledBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  badgePositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 11,
                  color: badgePositive ? AppColors.activeText : AppColors.cancelledText,
                ),
                const SizedBox(width: 2),
                Text(
                  badge,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badgePositive ? AppColors.activeText : AppColors.cancelledText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top listing row ───────────────────────────────────────────────────────────
class _TopListingRow extends StatelessWidget {
  final String title;
  final int views;
  final int maxViews;

  const _TopListingRow({
    required this.title,
    required this.views,
    required this.maxViews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '$views',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: views / maxViews,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

// ── Performance rows ──────────────────────────────────────────────────────────
class _PerformanceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PerformanceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceRowStar extends StatelessWidget {
  final String label;
  final String value;

  const _PerformanceRowStar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 16, color: AppColors.starColor),
        ],
      ),
    );
  }
}
