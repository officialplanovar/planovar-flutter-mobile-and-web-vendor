import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/ui/onboarding_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/register_screen.dart';
import '../../features/auth/ui/verify_email_screen.dart';
import '../../features/auth/ui/forgot_password_screen.dart';
import '../../features/setup/ui/setup_screens.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/home/ui/action_needed_screen.dart';
import '../../features/listings/ui/listings_screen.dart';
import '../../features/listings/ui/add_listing_type_screen.dart';
import '../../features/listings/ui/add_product_screen.dart';
import '../../features/listings/ui/add_service_screen.dart';
import '../../features/listings/ui/edit_listing_screen.dart';
import '../../features/listings/ui/add_listing_success_screen.dart';
import '../../features/orders/ui/orders_screen.dart';
import '../../features/orders/ui/order_detail_screen.dart';
import '../../features/messaging/ui/messages_screen.dart';
import '../../features/messaging/ui/conversation_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile/ui/profile_sub_screens.dart';
import '../../features/analytics/ui/analytics_screen.dart';
import '../../features/payouts/ui/payouts_screen.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../theme/app_colors.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
const _keyIsLoggedIn = 'vendor_isLoggedIn';

final _authPaths = [
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.verifyEmail,
  AppRoutes.forgotPassword,
  AppRoutes.resetPassword,
  AppRoutes.setupBusinessType,
  AppRoutes.setupProfile,
  AppRoutes.setupLocation,
  AppRoutes.setupPlan,
  AppRoutes.setupPayout,
  AppRoutes.setupSuccess,
];

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      if (state.matchedLocation == AppRoutes.splash) return null;
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      final currentPath = state.matchedLocation;
      final isOnAuthRoute = _authPaths.any(
        (p) => currentPath.startsWith(p.replaceAll(':id', '')),
      );
      if (!isLoggedIn && !isOnAuthRoute) return AppRoutes.onboarding;
      return null;
    },
    routes: [
      // ─── Splash ────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (ctx, route) =>const SplashScreen(),
      ),

      // ─── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (ctx, route) =>const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (ctx, route) =>const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (ctx, route) =>const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return VerifyEmailScreen(
            email: extra['email'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (ctx, route) =>const ForgotPasswordScreen(),
      ),

      // ─── Setup Flow ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.setupBusinessType,
        builder: (ctx, route) =>const SetupBusinessTypeScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupProfile,
        builder: (ctx, route) =>const SetupProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupLocation,
        builder: (ctx, route) =>const SetupLocationScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupPlan,
        builder: (ctx, route) =>const SetupPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupPayout,
        builder: (ctx, route) =>const SetupPayoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.setupSuccess,
        builder: (ctx, route) =>const SetupSuccessScreen(),
      ),

      // ─── Home sub-pages ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.actionNeeded,
        builder: (_, __) => const ActionNeededScreen(),
      ),

      // ─── Listings (full-screen) ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addListing,
        builder: (_, __) => const AddListingTypeScreen(),
      ),
      GoRoute(
        path: AppRoutes.addProduct,
        builder: (_, __) => const AddProductScreen(),
      ),
      GoRoute(
        path: AppRoutes.addService,
        builder: (_, __) => const AddServiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.editListing,
        builder: (_, state) =>
            EditListingScreen(listingId: state.pathParameters['id']!),
      ),

      // ─── Listing Success ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addListingSuccess,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AddListingSuccessScreen(
            productId: extra['productId'] as String? ?? '#PN-00000',
            sku: extra['sku'] as String? ?? 'SKU00000',
            isService: extra['isService'] as bool? ?? false,
          );
        },
      ),

      // ─── Shell (bottom nav) ────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (ctx, route) =>const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.listings,
                builder: (ctx, route) =>const ListingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (ctx, route) =>const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.messages,
                builder: (ctx, route) =>const MessagesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (ctx, route) =>const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ─── Order detail ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.orderDetail,
        builder: (_, state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),

      // ─── Conversation ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.conversation,
        builder: (_, state) =>
            ConversationScreen(conversationId: state.pathParameters['id']!),
      ),

      // ─── Analytics ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.analytics,
        builder: (ctx, route) =>const AnalyticsScreen(),
      ),

      // ─── Payouts ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.payouts,
        builder: (ctx, route) =>const PayoutsScreen(),
      ),

      // ─── Notifications ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.notifications,
        builder: (ctx, route) =>const NotificationsScreen(),
      ),

      // ─── Profile sub-pages ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (ctx, route) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionPlan,
        builder: (ctx, route) => const SubscriptionPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.bankDetails,
        builder: (ctx, route) => const BankDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.themeSettings,
        builder: (ctx, route) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.security,
        builder: (ctx, route) => const SecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (ctx, route) => const HelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (ctx, route) => const HelpScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (ctx, route) => const NotificationSettingsScreen(),
      ),
    ],
  );
}

// ─── App Shell (Bottom Navigation) ──────────────────────────────────────────

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const _AppShell({required this.shell});

  // Nav tabs excluding the centre FAB (Messages).
  // branch: maps to the StatefulShellBranch index.
  static const _tabs = [
    (icon: Icons.home_outlined,         activeIcon: Icons.home_rounded,         label: 'Home',     branch: 0),
    (icon: Icons.store_outlined,        activeIcon: Icons.store_rounded,        label: 'Listings', branch: 1),
    (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long_rounded, label: 'Orders',   branch: 2),
    (icon: Icons.person_outline_rounded,activeIcon: Icons.person_rounded,       label: 'Profile',  branch: 4),
  ];

  // Messages branch index in the StatefulShellRoute.
  static const _messagesBranch = 3;

  static const _fabGradient = LinearGradient(
    colors: [Color(0xFF6B6AF7), Color(0xFF3332D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget _buildTab(int branchIndex, IconData icon, IconData activeIcon, String label) {
    final isActive = shell.currentIndex == branchIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => shell.goBranch(
          branchIndex,
          initialLocation: branchIndex == shell.currentIndex,
        ),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 10,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final barHeight = 64.0 + bottomPadding;

    return SizedBox(
      height: barHeight + 20, // extra space so FAB can overflow top
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nav bar background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: barHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0x18000000), width: 0.5),
                ),
              ),
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: [
                  // Home
                  _buildTab(_tabs[0].branch, _tabs[0].icon, _tabs[0].activeIcon, _tabs[0].label),
                  // Listings
                  _buildTab(_tabs[1].branch, _tabs[1].icon, _tabs[1].activeIcon, _tabs[1].label),
                  // Centre FAB placeholder (takes up Expanded space)
                  const Expanded(child: SizedBox()),
                  // Orders
                  _buildTab(_tabs[2].branch, _tabs[2].icon, _tabs[2].activeIcon, _tabs[2].label),
                  // Profile
                  _buildTab(_tabs[3].branch, _tabs[3].icon, _tabs[3].activeIcon, _tabs[3].label),
                ],
              ),
            ),
          ),

          // Centre FAB — raised 20px above the nav bar top edge
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => shell.goBranch(
                  _messagesBranch,
                  initialLocation: _messagesBranch == shell.currentIndex,
                ),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _fabGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4544F4).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: shell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildNavBar(context),
          ),
        ],
      ),
    );
  }
}
