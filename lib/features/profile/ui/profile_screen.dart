import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../vendor/data/vendor_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  VendorModel? _vendor;

  @override
  void initState() {
    super.initState();
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) setState(() => _vendor = v);
    }).catchError((_) {});
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon')),
    );
  }

  String _locationLabel(VendorModel? v) {
    final loc = (v?.location as Map?) ?? const {};
    final parts = [loc['city'], loc['country']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .map((e) => '$e'.trim())
        .toList();
    return parts.isEmpty ? '' : parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final vendor = _vendor;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final topPadding = MediaQuery.of(context).padding.top;

    final businessName = vendor?.businessName ?? user?.name ?? 'Your business';
    final tag = (vendor?.tags.isNotEmpty ?? false) ? vendor!.tags.first : null;
    final subtitle = [_locationLabel(vendor), tag]
        .where((e) => e != null && e.isNotEmpty)
        .join(' · ');
    final tier = (vendor?.subscriptionTier ?? '').toUpperCase();
    final tierLabel = tier.isEmpty
        ? null
        : '${tier[0]}${tier.substring(1).toLowerCase()} Plan';

    return Scaffold(
      backgroundColor: context.c.background,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // ── Gradient header ──────────────────────────────────────────────────
          Container(
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
            padding: EdgeInsets.only(
              top: topPadding + 16,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + business name row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: context.c.primaryLight,
                      child: ClipOval(
                        child: AppNetworkImage(
                          url: vendor?.logoUrl ?? user?.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            width: 56,
                            height: 56,
                            color: context.c.primaryLight,
                            child: Center(
                              child: Text(
                                businessName.isNotEmpty
                                    ? businessName[0].toUpperCase()
                                    : 'V',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName,
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Pill badges row
                Row(
                  children: [
                    if (tierLabel != null) ...[
                      _PillBadge(
                        child: Text(
                          tierLabel,
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if ((vendor?.reviewCount ?? 0) > 0) ...[
                      _PillBadge(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              vendor!.ratingAvg.toStringAsFixed(1),
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFB800), size: 13),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (vendor?.isVerified ?? false)
                      _PillBadge(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/verified.svg',
                              width: 13,
                              height: 13,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      _PillBadge(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Unverified',
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ── General section ──────────────────────────────────────────────────
          _SectionLabel(label: 'General'),
          _MenuSection(
            items: [
              _MenuItem(
                asset: 'assets/icons/update-profile.svg',
                label: 'Update your Profile',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _MenuItem(
                asset: 'assets/icons/security.svg',
                label: 'Security',
                onTap: () => context.push(AppRoutes.security),
              ),
              _MenuItem(
                asset: 'assets/icons/reviews.svg',
                label: 'Reviews',
                onTap: () => context.push(AppRoutes.reviews),
              ),
              _MenuItem(
                asset: 'assets/icons/hugeicons_bank.svg',
                label: 'Linked Bank accounts',
                onTap: () => context.push(AppRoutes.bankDetails),
              ),
              _MenuItem(
                asset: 'assets/icons/gallery.svg',
                label: 'Gallery',
                onTap: () => context.push(AppRoutes.gallery),
              ),
              _MenuItem(
                asset: 'assets/icons/subscriptions.svg',
                label: 'Subscription Plans',
                onTap: () => context.push(AppRoutes.subscriptionPlan),
              ),
              _MenuItem(
                asset: 'assets/icons/language.svg',
                label: 'Language Preference',
                onTap: () => _comingSoon('Language preference'),
              ),
            ],
          ),

          // ── Preferences section ──────────────────────────────────────────────
          _SectionLabel(label: 'Preferences'),
          _MenuSection(
            items: [
              _MenuItem(
                asset: 'assets/icons/theme.svg',
                label: 'Theme',
                onTap: () => context.push(AppRoutes.themeSettings),
              ),
              _MenuItem(
                asset: 'assets/icons/customize-storefront.svg',
                label: 'Customize your Storefront',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _MenuItem(
                asset: 'assets/icons/notifications.svg',
                label: 'Notifications',
                onTap: () => context.push(AppRoutes.notificationSettings),
              ),
              _MenuItem(
                asset: 'assets/icons/help-and-support.svg',
                label: 'Help and Support',
                onTap: () => context.push(AppRoutes.help),
              ),
              _MenuItem(
                asset: 'assets/icons/terms-and-conditions.svg',
                label: 'Terms & Conditions',
                onTap: () => context.push(AppRoutes.termsAndConditions),
              ),
              _MenuItem(
                asset: 'assets/icons/leave-planovar.svg',
                label: 'Leave Planovar',
                onTap: () => context.push(AppRoutes.deleteAccount),
              ),
            ],
          ),

          // ── Sign out button ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _SignOutButton(),
          ),
        ],
      ),
    );
  }
}

// ── Pill badge ─────────────────────────────────────────────────────────────────
class _PillBadge extends StatelessWidget {
  final Widget child;

  const _PillBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
      ),
      child: child,
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          color: context.c.textSecondary,
        ),
      ),
    );
  }
}

// ── Menu section card ──────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _MenuTile(item: item),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: context.c.divider,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Menu item data ─────────────────────────────────────────────────────────────
class _MenuItem {
  final String asset; // SVG path under assets/icons/
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.asset,
    required this.label,
    required this.onTap,
  });
}

// ── Menu tile ──────────────────────────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.c.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                item.asset,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                    AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.c.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.c.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sign out button ────────────────────────────────────────────────────────────
class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Proper sign-out: clears the bearer token + resets auth state.
        context.read<AuthBloc>().add(const AuthSignOutRequested());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('vendor_isLoggedIn', false);
        if (context.mounted) context.go(AppRoutes.login);
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/sign-out.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                  Color(0xFFE53935), BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            Text(
              'Sign out',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
