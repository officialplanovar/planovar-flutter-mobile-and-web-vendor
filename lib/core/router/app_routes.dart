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
  static const setupKyc = '/setup/kyc';
  static const setupPayout = '/setup/payout'; // legacy, unused under subscription-only
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
  static const listingDetail = '/listings/detail/:id';
  static String listingDetailPath(String id) => '/listings/detail/$id';
  static const outOfStock = '/listings/out-of-stock';
  static const listingsOutOfStock = '/listings/out-of-stock';

  // ─── Orders / Bookings ────────────────────────────────────────────────────────
  static const orderDetail = '/orders/:id';
  static String orderDetailPath(String id) => '/orders/$id';
  static const cancelOrder = '/orders/:id/cancel';
  static String cancelOrderPath(String id) => '/orders/$id/cancel';
  static const leaveReview = '/orders/:id/review';
  static String leaveReviewPath(String id) => '/orders/$id/review';
  static const trackingDetail = '/orders/tracking/:id';
  static String trackingDetailPath(String id) => '/orders/tracking/$id';

  // ─── Messages ────────────────────────────────────────────────────────────────
  static const conversation = '/messages/:id';
  static String conversationPath(String id) => '/messages/$id';
  static const createQuote = '/messages/create-quote';
  static String createQuotePath(String conversationId) => '/messages/create-quote?convId=$conversationId';
  static String createQuoteForBookingPath(String bookingId) => '/messages/create-quote?bookingId=$bookingId';
  static const createInvoice = '/messages/create-invoice';
  static String createInvoicePath(String conversationId) => '/messages/create-invoice?convId=$conversationId';

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
  static const reviews = '/profile/reviews';
  static const gallery = '/profile/gallery';
  static const termsAndConditions = '/profile/terms';
}
