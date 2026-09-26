class AppConstants {
  static const String appName = 'Planovar Vendor';

  /// Active build environment: 'dev' | 'staging' | 'prod'.
  /// Injected at build time via `--dart-define-from-file=config/<env>.json`
  /// (see the app's Makefile / FLAVORS.md). Defaults to 'dev' for safety when
  /// no config is supplied.
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static bool get isProd => environment == 'prod';
  static bool get isStaging => environment == 'staging';
  static bool get isDev => environment == 'dev';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Custom URL scheme for the Google OAuth token-relay deep link
  /// (`<scheme>://auth?planovar_token=...`). Per-flavor so side-by-side installs
  /// don't collide; must match the Android manifestPlaceholder, the iOS
  /// CFBundleURLSchemes, and the API's MOBILE_SCHEMES allowlist.
  static const String oauthScheme = String.fromEnvironment(
    'OAUTH_SCHEME',
    defaultValue: 'planovarvendor',
  );

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

  // Currency
  static const String currencyCode = 'USD';
  static const String currencySymbol = '\$';
}
