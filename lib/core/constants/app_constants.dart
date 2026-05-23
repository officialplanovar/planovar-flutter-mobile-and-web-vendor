class AppConstants {
  static const String appName = 'Planovar Vendor';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const bool useMockData = true;

  // Subscription plan identifiers
  static const String planBasic = 'basic';
  static const String planFeatured = 'featured';
  static const String planPremium = 'premium';

  // Plan display names
  static const Map<String, String> planNames = {
    planBasic: 'Basic',
    planFeatured: 'Featured',
    planPremium: 'Premium',
  };

  // Pricing types
  static const String pricingFixed = 'FIXED';
  static const String pricingQuote = 'QUOTE';
  static const String pricingHourly = 'HOURLY';

  // Booking statuses
  static const String statusPending = 'PENDING';
  static const String statusConfirmed = 'CONFIRMED';
  static const String statusActive = 'ACTIVE';
  static const String statusCompleted = 'COMPLETED';
  static const String statusCancelled = 'CANCELLED';

  // Quote statuses
  static const String quotePending = 'PENDING';
  static const String quoteSent = 'SENT';
  static const String quoteAccepted = 'ACCEPTED';
  static const String quoteRejected = 'REJECTED';

  // Payout statuses
  static const String payoutPending = 'PENDING';
  static const String payoutPaid = 'PAID';
  static const String payoutFailed = 'FAILED';

  // Pagination
  static const int defaultPageSize = 20;

  // Shared preference keys
  static const String keyIsLoggedIn = 'vendor_isLoggedIn';
  static const String keyThemeMode = 'vendor_theme_mode';

  // Platform fee percentage
  static const double platformFeeRate = 0.05; // 5%

  // Currency
  static const String currencyCode = 'NGN';
  static const String currencySymbol = '₦';

  // Escrow hold period (days)
  static const int escrowHoldDays = 3;
}
