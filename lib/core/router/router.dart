import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../features/listings/ui/listing_detail_screen.dart';
import '../../features/listings/ui/out_of_stock_screen.dart';
import '../../features/orders/ui/orders_screen.dart';
import '../../features/orders/ui/order_detail_screen.dart';
import '../../features/orders/ui/cancel_order_screen.dart';
import '../../features/orders/ui/leave_review_screen.dart';
import '../../features/orders/ui/order_tracking_detail_screen.dart';
import '../../features/messaging/ui/messages_screen.dart';
import '../../features/messaging/ui/conversation_screen.dart';
import '../../features/messaging/ui/create_quote_screen.dart';
import '../../features/messaging/ui/create_invoice_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile/ui/profile_sub_screens.dart';
import '../../features/profile/ui/twofa_screens.dart';
import '../../features/profile/ui/reviews_screen.dart';
import '../../features/profile/ui/gallery_screen.dart';
import '../../features/profile/ui/support_screen.dart';
import '../../features/profile/ui/terms_screen.dart';
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
  AppRoutes.setupKyc,
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
        path: AppRoutes.setupKyc,
        builder: (ctx, route) =>const SetupKycScreen(),
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
        builder: (_, state) => EditListingScreen(
          listingId: state.pathParameters['id'] ?? '',
        ),
      ),

      // ─── Listing Detail ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.listingDetail,
        builder: (_, state) => ListingDetailScreen(
          listingId: state.pathParameters['id'] ?? '',
        ),
      ),

      // ─── Out of Stock ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.outOfStock,
        builder: (_, __) => const OutOfStockScreen(),
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

      // ─── Create Quote ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.createQuote,
        builder: (_, state) => CreateQuoteScreen(
          conversationId: state.uri.queryParameters['convId'] ?? '',
          bookingId: state.uri.queryParameters['bookingId'],
        ),
      ),

      // ─── Create Invoice ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.createInvoice,
        builder: (_, state) => CreateInvoiceScreen(
          conversationId: state.uri.queryParameters['convId'] ?? '',
        ),
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

      // ─── Cancel Order ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.cancelOrder,
        builder: (_, state) => CancelOrderScreen(orderId: state.pathParameters['id']!),
      ),

      // ─── Leave Review ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.leaveReview,
        builder: (_, state) => LeaveReviewScreen(orderId: state.pathParameters['id']!),
      ),

      // ─── Order Tracking Detail ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.trackingDetail,
        builder: (_, state) =>
            OrderTrackingDetailScreen(orderId: state.pathParameters['id']!),
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
        builder: (ctx, route) => const FaqScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (ctx, route) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        builder: (ctx, route) => const DeleteAccountScreen(),
      ),

      // ─── Profile — Reviews & Gallery ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.reviews,
        builder: (_, __) => const ReviewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.gallery,
        builder: (_, __) => const GalleryScreen(),
      ),

      // ─── Profile — Terms ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.termsAndConditions,
        builder: (_, __) => const TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: '/profile/terms/use',
        builder: (_, __) => const TermsOfUseScreen(),
      ),
      GoRoute(
        path: '/profile/terms/privacy',
        builder: (_, __) => const PrivacyPolicyScreen(),
      ),

      // ─── Profile — Change Password ────────────────────────────────────────
      GoRoute(
        path: '/profile/security/change-password',
        builder: (_, __) => const ChangePasswordScreen(),
      ),

      // ─── Profile — 2FA Flow ────────────────────────────────────────────────
      GoRoute(
        path: '/profile/2fa',
        builder: (_, __) => const TwoFAIntroScreen(),
      ),
      GoRoute(
        path: '/profile/2fa/setup',
        builder: (_, __) => const TwoFASetupScreen(),
      ),
      GoRoute(
        path: '/profile/2fa/confirm',
        builder: (_, __) => const TwoFAConfirmScreen(),
      ),
      GoRoute(
        path: '/profile/2fa/success',
        builder: (_, __) => const TwoFASuccessScreen(),
      ),

      // ─── Profile — Support ─────────────────────────────────────────────────
      GoRoute(
        path: '/profile/support',
        builder: (_, __) => const SupportScreen(),
      ),
      GoRoute(
        path: '/profile/support/call',
        builder: (_, __) => const CallSupportScreen(),
      ),
      GoRoute(
        path: '/profile/support/live-chat',
        builder: (_, __) => const LiveChatScreen(),
      ),
      GoRoute(
        path: '/profile/support/faq',
        builder: (_, __) => const FaqScreen(),
      ),
      GoRoute(
        path: '/profile/support/faq/:index',
        builder: (_, state) => FaqDetailScreen(
          index: int.tryParse(state.pathParameters['index'] ?? '0') ?? 0,
        ),
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
    (icon: 'assets/icons/nav-home.svg',     activeIcon: 'assets/icons/nav-home-active.svg',     label: 'Home',     branch: 0),
    (icon: 'assets/icons/nav-listings.svg', activeIcon: 'assets/icons/nav-listings-active.svg', label: 'Listings', branch: 1),
    (icon: 'assets/icons/nav-orders.svg',   activeIcon: 'assets/icons/nav-orders-active.svg',   label: 'Orders',   branch: 2),
    (icon: 'assets/icons/nav-profile.svg',  activeIcon: 'assets/icons/nav-profile-active.svg',  label: 'Profile',  branch: 4),
  ];

  // Messages branch index in the StatefulShellRoute.
  static const _messagesBranch = 3;

  static const _fabGradient = LinearGradient(
    colors: [Color(0xFF6B6AF7), Color(0xFF3332D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget _buildTab(BuildContext context, int branchIndex, String icon,
      String activeIcon, String label) {
    final isActive = shell.currentIndex == branchIndex;
    final inactiveColor = context.c.textSecondary;
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
            SvgPicture.asset(
              isActive ? activeIcon : icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primary : inactiveColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 10,
                color: isActive ? AppColors.primary : inactiveColor,
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
              decoration: BoxDecoration(
                color: context.c.surface,
                border: const Border(
                  top: BorderSide(color: Color(0x18000000), width: 0.5),
                ),
              ),
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: [
                  // Home
                  _buildTab(context, _tabs[0].branch, _tabs[0].icon, _tabs[0].activeIcon, _tabs[0].label),
                  // Listings
                  _buildTab(context, _tabs[1].branch, _tabs[1].icon, _tabs[1].activeIcon, _tabs[1].label),
                  // Centre FAB placeholder (takes up Expanded space)
                  const Expanded(child: SizedBox()),
                  // Orders
                  _buildTab(context, _tabs[2].branch, _tabs[2].icon, _tabs[2].activeIcon, _tabs[2].label),
                  // Profile
                  _buildTab(context, _tabs[3].branch, _tabs[3].icon, _tabs[3].activeIcon, _tabs[3].label),
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
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/chat.svg',
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
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
