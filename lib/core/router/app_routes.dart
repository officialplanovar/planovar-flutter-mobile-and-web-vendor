abstract class AppRoutes {
  // ─── Splash & Onboarding ─────────────────────────────────────────────────────
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // ─── Business Setup Flow ──────────────────────────────────────────────────────
  static const setupBusinessType = '/setup/business-type';
  static const setupProfile = '/setup/profile';
  static const setupLocation = '/setup/location';
  static const setupPlan = '/setup/plan';
  static const setupPayout = '/setup/payout';
  static const setupSuccess = '/setup/success';

  // ─── Main App (Shell routes) ──────────────────────────────────────────────────
  static const home = '/home';
  static const actionNeeded = '/home/action-needed';
  static const listings = '/listings';
  static const orders = '/orders';
  static const messages = '/messages';
  static const profile = '/profile';

  // ─── Listings ────────────────────────────────────────────────────────────────
  static const addListing = '/listings/add';
  static const addProduct = '/listings/add-product';
  static const addService = '/listings/add-service';
  static const editListing = '/listings/edit/:id';
  static String editListingPath(String id) => '/listings/edit/$id';
  static const addListingSuccess = '/listings/add-success';

  // ─── Orders / Bookings ────────────────────────────────────────────────────────
  static const orderDetail = '/orders/:id';
  static String orderDetailPath(String id) => '/orders/$id';

  // ─── Messages ────────────────────────────────────────────────────────────────
  static const conversation = '/messages/:id';
  static String conversationPath(String id) => '/messages/$id';

  // ─── Analytics ────────────────────────────────────────────────────────────────
  static const analytics = '/analytics';

  // ─── Payouts ─────────────────────────────────────────────────────────────────
  static const payouts = '/payouts';

  // ─── Notifications ────────────────────────────────────────────────────────────
  static const notifications = '/notifications';

  // ─── Profile sub-pages ────────────────────────────────────────────────────────
  static const editProfile = '/profile/edit';
  static const themeSettings = '/profile/theme';
  static const notificationSettings = '/profile/notifications';
  static const security = '/profile/security';
  static const help = '/profile/help';
  static const faq = '/profile/faq';
  static const deleteAccount = '/profile/delete-account';
  static const subscriptionPlan = '/profile/plan';
  static const bankDetails = '/profile/bank-details';
}
