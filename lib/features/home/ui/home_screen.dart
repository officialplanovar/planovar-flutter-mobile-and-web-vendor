import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../orders/bloc/orders_cubit.dart';
import '../../vendor/data/vendor_repository.dart';

/// Neutral placeholder shown only while the real vendor profile is loading.
const _kEmptyVendor = VendorModel(
  id: '',
  businessName: '',
  slug: '',
  ratingAvg: 0,
  reviewCount: 0,
  subscriptionTier: 'basic',
  isVerified: false,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VendorModel? _vendor;

  @override
  void initState() {
    super.initState();
    // Inquiry counts power the alert banner + stats.
    final orders = context.read<OrdersCubit>();
    if (orders.state.orders.isEmpty) orders.load();
    // Live vendor profile (rating, review count, business name).
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) setState(() => _vendor = v);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // Live data; neutral placeholders while the profile loads (no mock).
    final vendor = _vendor ?? _kEmptyVendor;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    // No schedule/calendar backend yet — show the empty state, not mock events.
    const schedule = <ScheduleItem>[];
    final summary = context.watch<OrdersCubit>().state.summary;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // ── Primary gradient header ─────────────────────────────────────
          _GradientHeader(vendor: vendor, user: user),

          // ── Scrollable body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                ((context.screenWidth - 1000) / 2).clamp(0.0, 1000.0),
                0,
                ((context.screenWidth - 1000) / 2).clamp(0.0, 1000.0),
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alert banner — pending inquiries needing a response
                  _AlertBanner(
                    count: summary.actionNeeded,
                    onTap: () => context.push(AppRoutes.actionNeeded),
                  ),

                  const SizedBox(height: 12),

                  // Stats grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _StatsGrid(
                      vendor: vendor,
                      activeCount: summary.confirmed,
                      pendingCount: summary.actionNeeded,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Today's Schedule
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SectionHeader(
                      title: "Today's Schedule",
                      onViewAll: () {},
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ScheduleSection(schedule: schedule),
                  ),

                  const SizedBox(height: 28),

                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SectionHeader(
                      title: 'Quick Action',
                      onViewAll: () {},
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _QuickActions(context: context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Header ────────────────────────────────────────────────────────────

class _GradientHeader extends StatelessWidget {
  final dynamic vendor;
  final dynamic user;

  const _GradientHeader({required this.vendor, required this.user});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Derive the location from the vendor's saved profile.
    final loc = (vendor.location as Map?) ?? const {};
    final locParts = [loc['city'], loc['country']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .map((e) => '$e'.trim())
        .toList();
    final locationLabel = locParts.isEmpty ? 'Nigeria' : locParts.join(', ');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: topPadding + 12),

          // Location row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                locationLabel,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Avatar · greeting · bell
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: ClipOval(
                    child: AppNetworkImage(
                      url: user?.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeGreeting(),
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendor.businessName as String,
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bell button
                GestureDetector(
                  onTap: () => context.push(AppRoutes.notifications),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B3B),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.urbanist(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
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
        ],
      ),
    );
  }
}

// ── Alert Banner ───────────────────────────────────────────────────────────────

class _AlertBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _AlertBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count New requests need your attention',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You have $count new requests for your listings',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: context.c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats Grid ─────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final dynamic vendor;
  final int activeCount;
  final int pendingCount;

  const _StatsGrid({
    required this.vendor,
    required this.activeCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    final reviewCount = (vendor.reviewCount as int?) ?? 0;

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          label: 'Confirmed Bookings',
          value: '$activeCount',
          badge: _StatBadge.up(''),
        ),
        _StatCard(
          label: 'Pending Requests',
          value: '$pendingCount',
          badge: _StatBadge.down(''),
        ),
        _StatCard(
          label: 'This month',
          value: '$activeCount bookings',
          badge: _StatBadge.up(''),
        ),
        _StatCard(
          label: 'Avg Rating',
          value: '${(vendor.ratingAvg as num?) ?? 0}',
          ratingPrefix: true,
          reviewsText: 'from $reviewCount reviews',
        ),
      ],
    );
  }
}

class _StatBadge {
  final String text;
  final bool isUp;

  const _StatBadge.up(this.text) : isUp = true;
  const _StatBadge.down(this.text) : isUp = false;
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final _StatBadge? badge;
  final bool ratingPrefix;
  final String? reviewsText;

  const _StatCard({
    required this.label,
    required this.value,
    this.badge,
    this.ratingPrefix = false,
    this.reviewsText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.c.surface,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: context.c.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          // Value row (with optional star prefix)
          const SizedBox(height: 6),
          Row(
            children: [
              if (ratingPrefix) ...[
                const Icon(Icons.star_rounded, color: AppColors.starColor, size: 18),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Badge or reviews text
          if (badge != null)
            Row(
              children: [
                Icon(
                  badge!.isUp
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color: badge!.isUp ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 2),
                Text(
                  badge!.text,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badge!.isUp ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            )
          else if (reviewsText != null)
            Text(
              reviewsText!,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: context.c.textPrimary,
            ),
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'View all',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Schedule Section ───────────────────────────────────────────────────────────

class _ScheduleSection extends StatelessWidget {
  final List<ScheduleItem> schedule;

  const _ScheduleSection({required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.c.border),
        ),
        child: Center(
          child: Text(
            'No schedule for today',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: context.c.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.border),
      ),
      child: Column(
        children: schedule.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          // Parse "09:00 AM" → "09\nAM"  or "02:00 PM" → "02\nPM"
          final parts = item.time.split(' ');
          final timeParts = (parts.isNotEmpty ? parts[0] : '').split(':');
          final hour = timeParts.isNotEmpty ? timeParts[0] : '';
          final period = parts.length > 1 ? parts[1] : '';

          return Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Time block
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hour,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              period,
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.c.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.clientName,
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: context.c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.c.textHint,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < schedule.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16, color: context.c.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Quick Actions 2×2 grid ─────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final BuildContext context;

  const _QuickActions({required this.context});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_rounded,
        label: 'Add Listing',
        bgColor: AppColors.primary,
        iconColor: Colors.white,
        onTap: () => _showListingTypeBottomSheet(context),
      ),
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: 'Analytics',
        bgColor: const Color(0xFFFFF3DC),
        iconColor: const Color(0xFFF5A623),
        onTap: () => context.push(AppRoutes.analytics),
      ),
      _QuickAction(
        icon: Icons.upload_rounded,
        label: 'Upgrade Plan',
        bgColor: const Color(0xFFF0EFFE),
        iconColor: AppColors.primary,
        onTap: () => context.push(AppRoutes.subscriptionPlan),
      ),
      _QuickAction(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Payouts',
        bgColor: const Color(0xFFE6F9F0),
        iconColor: const Color(0xFF27AE60),
        onTap: () => context.push(AppRoutes.payouts),
      ),
    ];

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.55,
      crossAxisSpacing: 12,
      mainAxisSpacing: 8,
      children: actions.map((a) {
        return GestureDetector(
          onTap: a.onTap,
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: context.c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.c.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: a.bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a.icon, color: a.iconColor, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  a.label,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}

// ── Listing Type Bottom Sheet ──────────────────────────────────────────────────

void _showListingTypeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => const _ListingTypeSheet(),
  );
}

class _ListingTypeSheet extends StatefulWidget {
  const _ListingTypeSheet();

  @override
  State<_ListingTypeSheet> createState() => _ListingTypeSheetState();
}

class _ListingTypeSheetState extends State<_ListingTypeSheet> {
  String? _selected = 'service';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 0, 24, MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Cancel + title row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'Listing Type',
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select the type of listing you want to create',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: context.c.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          _TypeCard(
            type: 'service',
            icon: Icons.work_outline_rounded,
            title: 'Service',
            subtitle: 'bookable appointment',
            selected: _selected,
            onTap: (t) => setState(() => _selected = t),
          ),

          const SizedBox(height: 14),

          _TypeCard(
            type: 'product',
            icon: Icons.inventory_2_outlined,
            title: 'Product',
            subtitle: 'Physical item for rent or sale',
            selected: _selected,
            onTap: (t) => setState(() => _selected = t),
          ),

          const SizedBox(height: 28),

          AppButton.primary(
            'Proceed',
            onTap: _selected == null
                ? null
                : () {
                    Navigator.pop(context);
                    if (_selected == 'service') {
                      context.push(AppRoutes.addService);
                    } else {
                      context.push(AppRoutes.addProduct);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? selected;
  final void Function(String) onTap;

  const _TypeCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;
    return GestureDetector(
      onTap: () => onTap(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? context.c.primaryLight : context.c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.c.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : context.c.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : context.c.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

/// Time-of-day greeting ("Good morning/afternoon/evening,").
String _timeGreeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Good morning,';
  if (h < 17) return 'Good afternoon,';
  return 'Good evening,';
}
