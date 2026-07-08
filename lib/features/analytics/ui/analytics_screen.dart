import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/vendor_model.dart';
import '../../listings/bloc/listings_cubit.dart';
import '../../orders/bloc/orders_cubit.dart';
import '../../vendor/data/vendor_repository.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  VendorModel? _vendor;

  @override
  void initState() {
    super.initState();
    final listings = context.read<ListingsCubit>();
    if (listings.state.listings.isEmpty) listings.load();
    final orders = context.read<OrdersCubit>();
    if (orders.state.orders.isEmpty) orders.load();
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) setState(() => _vendor = v);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<ListingsCubit>().state.listings;
    final orders = context.watch<OrdersCubit>().state.orders;

    final totalListings = listings.length;
    final activeListings = listings.where((l) => l.isActive).length;
    final totalInquiries = orders.length;
    final pendingInquiries =
        orders.where((o) => o.status.toUpperCase() == 'PENDING').length;
    final rating = _vendor?.ratingAvg ?? 0;
    final reviewCount = _vendor?.reviewCount ?? 0;

    return Scaffold(
      backgroundColor: context.c.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Analytics',
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
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.5,
            children: [
              _StatCard(
                icon: Icons.storefront_outlined,
                label: 'Active Listings',
                value: '$activeListings',
                sub: 'of $totalListings total',
              ),
              _StatCard(
                icon: Icons.mark_email_unread_outlined,
                label: 'Inquiries',
                value: '$totalInquiries',
                sub: '$pendingInquiries awaiting reply',
              ),
              _StatCard(
                icon: Icons.star_outline_rounded,
                label: 'Rating',
                value: reviewCount > 0 ? rating.toStringAsFixed(1) : '—',
                sub: '$reviewCount reviews',
              ),
              _StatCard(
                icon: Icons.verified_outlined,
                label: 'Plan',
                value: (_vendor?.subscriptionTier ?? '—').isEmpty
                    ? '—'
                    : _titleCase(_vendor!.subscriptionTier),
                sub: _vendor?.isVerified == true ? 'Verified' : 'Unverified',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.c.border),
            ),
            child: Column(
              children: [
                Icon(Icons.insights_outlined,
                    size: 40, color: context.c.textHint),
                const SizedBox(height: 12),
                Text(
                  'Detailed performance analytics',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Trends, profile views and conversion charts are coming soon.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: context.c.textPrimary,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.c.textPrimary,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  color: context.c.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
