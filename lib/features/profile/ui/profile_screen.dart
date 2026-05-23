import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/network_image_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendor = MockData.currentVendor;
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // Profile header card
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryLight,
                      child: ClipOval(
                        child: AppNetworkImage(
                          url: user.image,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            width: 64,
                            height: 64,
                            color: AppColors.primaryLight,
                            child: Center(
                              child: Text(
                                vendor.businessName.isNotEmpty
                                    ? vendor.businessName[0].toUpperCase()
                                    : 'V',
                                style: GoogleFonts.urbanist(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.editProfile),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.businessName,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.starColor,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${vendor.ratingAvg} · ${vendor.reviewCount} reviews',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (vendor.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Featured',
                                style: GoogleFonts.urbanist(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Business section
          _SectionLabel(label: 'Business'),
          _MenuSection(
            items: [
              _MenuItem(
                icon: Icons.store_rounded,
                label: 'Edit Business Profile',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _MenuItem(
                icon: Icons.workspace_premium_rounded,
                label: 'Subscription Plan',
                trailing: _PlanBadge(plan: vendor.subscriptionTier),
                onTap: () => context.push(AppRoutes.subscriptionPlan),
              ),
              _MenuItem(
                icon: Icons.account_balance_rounded,
                label: 'Bank Details',
                onTap: () => context.push(AppRoutes.bankDetails),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Analytics section
          _SectionLabel(label: 'Analytics'),
          _MenuSection(
            items: [
              _MenuItem(
                icon: Icons.bar_chart_rounded,
                label: 'Analytics',
                onTap: () => context.push(AppRoutes.analytics),
              ),
              _MenuItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Payouts',
                onTap: () => context.push(AppRoutes.payouts),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Preferences section
          _SectionLabel(label: 'Preferences'),
          _MenuSection(
            items: [
              _MenuItem(
                icon: Icons.notifications_rounded,
                label: 'Notifications',
                onTap: () => context.push(AppRoutes.notificationSettings),
              ),
              _MenuItem(
                icon: Icons.palette_rounded,
                label: 'Theme',
                onTap: () => context.push(AppRoutes.themeSettings),
              ),
              _MenuItem(
                icon: Icons.lock_rounded,
                label: 'Security',
                onTap: () => context.push(AppRoutes.security),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Support section
          _SectionLabel(label: 'Support'),
          _MenuSection(
            items: [
              _MenuItem(
                icon: Icons.help_rounded,
                label: 'Help & Support',
                onTap: () => context.push(AppRoutes.help),
              ),
              _MenuItem(
                icon: Icons.quiz_rounded,
                label: 'FAQs',
                onTap: () => context.push(AppRoutes.faq),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _LogoutButton(),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _MenuTile(item: item),
              if (i < items.length - 1)
                const Divider(height: 1, indent: 56, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (item.trailing != null) ...[
              item.trailing!,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String plan;

  const _PlanBadge({required this.plan});

  @override
  Widget build(BuildContext context) {
    final label = plan[0].toUpperCase() + plan.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('vendor_isLoggedIn', false);
        if (context.mounted) context.go(AppRoutes.onboarding);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error, width: 1.5),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              Text(
                'Log Out',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
