// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get languageIntro =>
      'Choose your preferred language. English is available now — more are on the way.';

  @override
  String get comingSoon => 'Soon';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get search => 'Search';

  @override
  String get seeAll => 'See All';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navEvents => 'Events';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get navListings => 'Listings';

  @override
  String get navOrders => 'Orders';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue your Journey on Planovar';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'Enter your Email address';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get orLabel => 'or';

  @override
  String get noAccountQuestion => 'Don\'t Have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get onboardingTitle1 => 'Unlock thousands of event clients';

  @override
  String get onboardingSubtitle1 =>
      'Connect with couples, corporates, and event planners in your location, all actively searching for vendors like you';

  @override
  String get onboardingTitle2 => 'Manage Everything in one Dashboard';

  @override
  String get onboardingSubtitle2 =>
      'Track your inquiries, bookings, and conversations from a single workspace';

  @override
  String get onboardingTitle3 => 'Showcase your work, get discovered';

  @override
  String get onboardingSubtitle3 =>
      'List your products, services and rentals — then subscribe to climb search rankings and reach event planners first.';

  @override
  String get onboardingListBusiness => 'List my business';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get loginSubtitle => 'Sign in to your vendor account';

  @override
  String get emailPlaceholder => 'yourname@business.com';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get registerTitle => 'Create your vendor account';

  @override
  String get registerSubtitle => 'Start listing your business on Planovar';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'e.g. Ada';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'e.g. Obi';

  @override
  String get businessName => 'Business Name';

  @override
  String get businessNameHint => 'e.g. Sugared Dreams Cakery';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get dobPlaceholder => 'DD / MM / YYYY';

  @override
  String get selectDob => 'Select your date of birth';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '8012345678';

  @override
  String get createPassword => 'Create Password';

  @override
  String get createPasswordHint => 'Min 8 characters';

  @override
  String get registerAgreePrefix => 'By checking the box you agree to our ';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get registerAgreeAnd => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signInAction => 'Sign in';

  @override
  String get forgotResetTitle => 'Reset your password';

  @override
  String get forgotResetIntro =>
      'Enter your email address and we\'ll send you a 6-digit code to reset your password.';

  @override
  String forgotResetSentTo(String email) {
    return 'A reset code has been sent to $email. Check your inbox.';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSuccess =>
      'Password reset successfully. Please sign in.';

  @override
  String get resetCreateNewPassword => 'Create a new password';

  @override
  String get resetCodeSentTo => 'Enter the 6-digit code sent to ';

  @override
  String get resetChoosePassword => ' and choose a new password.';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get sixDigitCode => '6-digit code';

  @override
  String get newPassword => 'New Password';

  @override
  String get atLeast8Chars => 'At least 8 characters';

  @override
  String get mustBeAtLeast8Chars => 'Must be at least 8 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get verifyEmailTitle => 'Verify your Email';

  @override
  String get verifyEmailIntro => 'We\'ve sent a 6-digit OTP to your email';

  @override
  String get verifyNewCodeSent => 'A new code has been sent';

  @override
  String verifyCouldNotResend(String error) {
    return 'Could not resend code: $error';
  }

  @override
  String get proceed => 'Proceed';

  @override
  String verifyResendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCodeAction => 'Resend code';

  @override
  String get setupBusinessSetup => 'Business Setup';

  @override
  String get setupBusinessProfileTitle => 'Business profile';

  @override
  String get setupBusinessProfileSubtitle => 'Tell clients who you are';

  @override
  String get setupLicensedBusiness => 'Licensed Business';

  @override
  String get setupLicensedBusinessDesc =>
      'Registered company, agency or studio';

  @override
  String get setupFreelancer => 'Freelancer';

  @override
  String get setupFreelancerDesc => 'Individual offering professional services';

  @override
  String get setupCouldNotLoadCategories => 'Could not load categories';

  @override
  String get setupCouldNotReadFile => 'Could not read the selected file';

  @override
  String get setupFileTooLarge => 'File is larger than 5 MB';

  @override
  String get setupBusinessLogoOptional => 'Business logo (optional)';

  @override
  String get setupBusinessDescription => 'Business Description';

  @override
  String get setupBusinessDescriptionHint =>
      'Tell clients what makes your business special, your experience, and what you offer...';

  @override
  String get setupProofOfOwnership => 'Proof of Ownership';

  @override
  String get setupProofOptionalFreelancers => '(optional for freelancers)';

  @override
  String get setupDocumentUploaded => 'Document uploaded';

  @override
  String get setupTapToReplace => 'Tap to replace';

  @override
  String get setupTapToUpload => 'Tap to upload';

  @override
  String get setupUploadFileTypes => 'JPG, PNG or PDF up to 5mb';

  @override
  String get setupCategoryTags => 'Category tags';

  @override
  String get setupNoCategories => 'No categories available yet';

  @override
  String get setupLocationTitle => 'Location & reach';

  @override
  String get setupLocationSubtitle => 'Where do you operate?';

  @override
  String get setupTurnOnLocation => 'Turn on location services to use this.';

  @override
  String get setupLocationDenied =>
      'Location permission denied — pick your city manually.';

  @override
  String get setupCouldNotDetermineCity =>
      'Couldn\'t determine your city — please pick it manually.';

  @override
  String get setupCouldNotGetLocation =>
      'Couldn\'t get your location. Please pick your city manually.';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectYourCity => 'Select your city';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get setupLocating => 'Locating…';

  @override
  String get setupUseCurrentLocation => 'Use my current location';

  @override
  String get setupVendorType => 'Vendor type';

  @override
  String get setupProductsOnly => 'Products Only';

  @override
  String get setupServicesOnly => 'Services only';

  @override
  String get setupBothProductsServices => 'Both products & services';

  @override
  String get setupChoosePlanTitle => 'Choose your plan';

  @override
  String get setupChoosePlanSubtitle => 'Upgrade anytime. Cancel anytime.';

  @override
  String get setupCouldNotLoadPlans =>
      'Could not load plans. Check your connection and try again.';

  @override
  String setupSelectPlan(String plan) {
    return 'Select $plan';
  }

  @override
  String get setupSkipForNow => 'Skip for now';

  @override
  String get setupVerifyIdentityTitle => 'Verify your identity';

  @override
  String get setupVerifyIdentitySubtitle =>
      'Upload your NIN, and CAC if you run a licensed business. Stored securely.';

  @override
  String get setupUploaded => 'Uploaded';

  @override
  String get setupUploadNin => 'Upload your NIN slip';

  @override
  String get setupUploadCac => 'Upload your CAC document';

  @override
  String get setupPaymentNotCompleted =>
      'Payment not completed — you can subscribe to a paid plan anytime from your profile.';

  @override
  String get setupSomethingWentWrong => 'Something went wrong';

  @override
  String get setupSettingUp => 'Setting up…';

  @override
  String get setupFinishSetup => 'Finish setup';

  @override
  String get setupCompleteVerificationLater =>
      'You can complete verification later from your profile.';

  @override
  String get selectBank => 'Select Bank';

  @override
  String get setupPayoutTitle => 'Payout details';

  @override
  String get setupPayoutSubtitle => 'Where should we send your earnings?';

  @override
  String get setupBankName => 'Bank name';

  @override
  String get setupSelectYourBank => 'Select your bank';

  @override
  String get setupAccountNumber => 'Account number';

  @override
  String get setupAccountNumberHint => '0123456789';

  @override
  String get setupAccountName => 'Account name';

  @override
  String get setupAutoVerified => 'Auto verified';

  @override
  String get setupPayoutSchedule => 'Payout schedule';

  @override
  String get setupPayoutRolling => 'Rolling · 24–48hrs after completion';

  @override
  String get setupPayoutCommission =>
      'Platform commission · Deducted before payout';

  @override
  String get setupMinimumPayout => 'Minimum payout · ₦1,000';

  @override
  String get setupSecuredByPaystack => 'Secured by Paystack';

  @override
  String get setupSavePayoutDetails => 'Save Payout Details';

  @override
  String get setupAllSet => 'You\'re all set!';

  @override
  String get setupProfileLive =>
      'Your vendor profile is live on Planovar. Start adding your products and services to reach thousands of event planners in Lagos.';

  @override
  String get setupAddFirstListing => 'Add your first listing';

  @override
  String get setupAddFirstListingSub => 'Products, services or rentals';

  @override
  String get setupUpgradePlan => 'Upgrade your plan';

  @override
  String get setupUpgradePlanSub => 'Get more visibility & analytics';

  @override
  String get setupGoToDashboard => 'Go to Dashboard';

  @override
  String get payCompletePayment => 'Complete payment';

  @override
  String get paySecurePayment => 'Secure payment';

  @override
  String get payBrowserFailed =>
      'We couldn\'t open your browser. Tap below to open the secure Paystack checkout.';

  @override
  String get payBrowserOpened =>
      'We\'ve opened the secure Paystack checkout in your browser. Finish your payment there, then come back and tap the button below.';

  @override
  String get payOpenPaymentPage => 'Open payment page';

  @override
  String get payReopenPaymentPage => 'Reopen payment page';

  @override
  String get payCompletedPayment => 'I\'ve completed payment';

  @override
  String get homeTodaysSchedule => 'Today\'s Schedule';

  @override
  String get homeQuickAction => 'Quick Action';

  @override
  String get viewAll => 'View all';

  @override
  String homeNewRequestsAttention(int count) {
    return '$count New requests need your attention';
  }

  @override
  String homeNewRequestsSubtitle(int count) {
    return 'You have $count new requests for your listings';
  }

  @override
  String get homeConfirmedBookings => 'Confirmed Bookings';

  @override
  String get homePendingRequests => 'Pending Requests';

  @override
  String get homeThisMonth => 'This month';

  @override
  String homeBookingsCount(int count) {
    return '$count bookings';
  }

  @override
  String get homeAvgRating => 'Avg Rating';

  @override
  String homeFromReviews(int count) {
    return 'from $count reviews';
  }

  @override
  String get homeNoSchedule => 'No schedule for today';

  @override
  String get homeAddListing => 'Add Listing';

  @override
  String get homeAnalytics => 'Analytics';

  @override
  String get homeUpgradePlanShort => 'Upgrade Plan';

  @override
  String get homePayouts => 'Payouts';

  @override
  String get homeGoodMorning => 'Good morning,';

  @override
  String get homeGoodAfternoon => 'Good afternoon,';

  @override
  String get homeGoodEvening => 'Good evening,';

  @override
  String get listingTypeTitle => 'Listing Type';

  @override
  String get listingTypeSubtitle =>
      'Select the type of listing you want to create';

  @override
  String get listingTypeService => 'Service';

  @override
  String get listingTypeServiceDesc => 'bookable appointment';

  @override
  String get listingTypeProduct => 'Product';

  @override
  String get listingTypeProductDesc => 'Physical item for rent or sale';

  @override
  String get homeActionNeeded => 'Action Needed';

  @override
  String get homeAllCaughtUp => 'You’re all caught up';

  @override
  String get homeNoInquiriesWaiting =>
      'No inquiries are waiting on your response.';

  @override
  String get homeNewInquiry => 'New inquiry';

  @override
  String get homeNewBadge => 'New';

  @override
  String get homeOpenRespond => 'Open & Respond';

  @override
  String get addListingNewListing => 'New Listing';

  @override
  String get addListingServiceDesc => 'Bookable appointment';

  @override
  String get addSuccessSuccessfully => 'Successfully';

  @override
  String addSuccessAddedTitle(String label) {
    return '$label Added ';
  }

  @override
  String addSuccessPendingSubtitle(String label) {
    return 'Your $label has been saved. It will become visible to clients once your account is verified.';
  }

  @override
  String get addSuccessLiveService =>
      'Your service has been added successfully and is currently Live';

  @override
  String get addSuccessLiveProduct =>
      'Your product has been added successfully and is currently Live';

  @override
  String get addSuccessPendingWarning =>
      'Pending verification — clients can\'t see your listings until an admin verifies your account. We\'ll let you know once you\'re approved.';

  @override
  String addSuccessIdLabel(String label) {
    return '$label ID';
  }

  @override
  String get addSuccessSku => 'SKU';

  @override
  String get addSuccessDateCreated => 'Date Created';

  @override
  String addSuccessViewLabel(String label) {
    return 'View $label';
  }

  @override
  String get listingBadgeProductRental => 'Product (Rental)';

  @override
  String listingPerDay(String price) {
    return '$price / day';
  }

  @override
  String get listingQuoteBased => 'Quote based';

  @override
  String get listingsMyListings => 'My Listings';

  @override
  String listingsTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String listingsTabServices(int count) {
    return 'Services ($count)';
  }

  @override
  String listingsTabProducts(int count) {
    return 'Products ($count)';
  }

  @override
  String listingsTabRentals(int count) {
    return 'Rentals ($count)';
  }

  @override
  String listingsOutOfStockCount(int count) {
    return '$count Items are out of Stock, ';
  }

  @override
  String get listingsClickToUpdate => 'Click to update';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get listingsPendingReview => 'Pending review';

  @override
  String get listingsEmptyTitle => 'No listings here yet';

  @override
  String get listingsEmptySubtitle => 'Tap + to add your first listing';

  @override
  String get listingsAddListing => 'Add listing';

  @override
  String get listingsCouldNotLoad => 'Could not load your listings';

  @override
  String get oosTitle => 'Listings out of stock';

  @override
  String get oosRental => 'Rental';

  @override
  String oosReactivated(String noun) {
    return '$noun reactivated';
  }

  @override
  String get oosBadge => 'Out of Stock';

  @override
  String get oosRestock => 'Re stock';

  @override
  String get oosEmptyTitle => 'All listings are in stock!';

  @override
  String get oosEmptySubtitle => 'No out-of-stock items in this category';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get apGenerateSkuHint =>
      'Enter the product name first, then generate an SKU.';

  @override
  String get apNameDescRequired => 'Product name and description are required';

  @override
  String get apSelectCategory => 'Please select a category';

  @override
  String get apSelectACategory => 'Select a category';

  @override
  String get apNoCategoriesProfile =>
      'You haven\'t added any categories to your profile yet. Add them under Profile → Business Details to list products here.';

  @override
  String get apOnlyRegisteredCategories =>
      'Only your registered categories are shown. Add more in Profile → Business Details.';

  @override
  String get apForSale => 'For Sale';

  @override
  String get apForRent => 'For Rent';

  @override
  String get apTitle => 'Add a Product';

  @override
  String get apSubtitle => 'Add a product to your catalogue';

  @override
  String get apProductName => 'Product Name';

  @override
  String get apProductNameHint => 'Enter product name...';

  @override
  String get apProductDescription => 'Product Description';

  @override
  String get apProductDescriptionHint => 'Describe your product...';

  @override
  String get apProductPrice => 'Product Price';

  @override
  String get apPricePerDay => 'Price Per Day';

  @override
  String get apRefundableDeposit => 'Refundable Deposit';

  @override
  String get apRentalDuration => 'Rental Duration (days)';

  @override
  String get apRentalDurationHint => 'e.g. 3';

  @override
  String get apSkuHint => 'Enter product SKU...';

  @override
  String get apGenerateForMe => 'Generate for me';

  @override
  String get apQuantityInStock => 'Quantity in Stock';

  @override
  String get apQuantityHint => 'How many do you have in stock';

  @override
  String get apAvailableSizes => 'Available Sizes (Optional)';

  @override
  String get apTags => 'Tags';

  @override
  String get apTagsHint => 'e.g. Wedding, Cake, Luxury';

  @override
  String get apProductPhotos => 'Product Photos';

  @override
  String get apFrontPhoto => 'Front Photo';

  @override
  String get apBackPhoto => 'Back Photo';

  @override
  String get apSidePhoto => 'Side Photo';

  @override
  String get apDetailPhoto => 'Detail Photo';

  @override
  String get apPublishing => 'Publishing…';

  @override
  String get apPublishProduct => 'Publish Product';

  @override
  String get gotIt => 'Got it';

  @override
  String get asNameDescRequired => 'Service name and description are required';

  @override
  String get asNoCategoriesProfile =>
      'You haven\'t added any categories to your profile yet. Add them under Profile → Business Details to list services here.';

  @override
  String get asCancellationPolicy => 'Cancellation Policy';

  @override
  String get policyFlexible => 'Flexible';

  @override
  String get policyModerate => 'Moderate';

  @override
  String get policyStrict => 'Strict';

  @override
  String get policyFlexibleDesc =>
      'Full refund if the client cancels up to 24 hours before the event.';

  @override
  String get policyModerateDesc =>
      '50% refund if cancelled at least 7 days before the event; none after.';

  @override
  String get policyStrictDesc => 'No refund once the booking is confirmed.';

  @override
  String get asCategoryInfo =>
      'The service category clients browse by. Only the categories you registered on your profile appear here.';

  @override
  String get asPriceRange => 'Price Range';

  @override
  String get asPriceRangeInfo =>
      'The typical price band for this service. Clients see it as a guide; the final amount is agreed in your quote.';

  @override
  String get asMin => 'Min';

  @override
  String get asMax => 'Max';

  @override
  String get asServiceDuration => 'Service Duration';

  @override
  String get durationDays => 'Days';

  @override
  String get durationHours => 'Hours';

  @override
  String get durationMins => 'Mins';

  @override
  String get asDurationHint => 'Enter duration value...';

  @override
  String get asSelectPolicy => 'Select a policy';

  @override
  String get asCancellationPolicyInfo =>
      'How refunds work if a client cancels. Choose the level that best fits your business.';

  @override
  String get asTitle => 'Add a Service';

  @override
  String get asSubtitle => 'Add a service for your business';

  @override
  String get asServiceName => 'Service Name';

  @override
  String get asServiceNameHint => 'Enter service name...';

  @override
  String get asServiceNameInfo =>
      'A short, clear name clients will see, e.g. \"Wedding Photography — Full Day\".';

  @override
  String get asServiceDescription => 'Service Description';

  @override
  String get asServiceDescriptionHint => 'Describe your service...';

  @override
  String get asServiceDescriptionInfo =>
      'What\'s included, your experience, and what clients can expect. The more detail, the more trust.';

  @override
  String get asTagsHint => 'e.g. Wedding, Photography, Outdoor';

  @override
  String get asServicePhotos => 'Service Photos';

  @override
  String asPhotoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get asPublishService => 'Publish Service';

  @override
  String get loading => 'Loading…';

  @override
  String get ldNotFound => 'Listing not found';

  @override
  String get ldServiceLower => 'service';

  @override
  String get ldProductLower => 'product';

  @override
  String ldDeleted(String noun) {
    return '$noun deleted';
  }

  @override
  String ldDeactivated(String noun) {
    return '$noun deactivated';
  }

  @override
  String get ldEditService => 'Edit Service';

  @override
  String get ldEditProduct => 'Edit Product';

  @override
  String get ldDeleteService => 'Delete Service';

  @override
  String get ldDeleteProduct => 'Delete Product';

  @override
  String get ldDeactivateService => 'Deactivate Service';

  @override
  String get ldDeactivateProduct => 'Deactivate Product';

  @override
  String get ldViews30d => 'Views (30d)';

  @override
  String get ldRating => 'Rating';

  @override
  String get ldNoReviews => 'No reviews yet';

  @override
  String get ldFixedPrice => 'Fixed price';

  @override
  String get ldStartingFrom => 'Starting from';

  @override
  String get ldQuoteOnRequest => 'Quote on request';

  @override
  String get ldType => 'Type';

  @override
  String get ldPricePerDay => 'Price per day';

  @override
  String get ldStock => 'Stock';

  @override
  String get ldCancellationPolicy => 'Cancellation policy';

  @override
  String get ldPrice => 'Price';

  @override
  String ldFrom(String price) {
    return 'From $price';
  }

  @override
  String get ldPricing => 'Pricing';

  @override
  String get ldDuration => 'Duration';

  @override
  String ldInStock(int count) {
    return '$count in stock';
  }

  @override
  String get ldStatus => 'Status';

  @override
  String get ldListed => 'Listed';

  @override
  String ldDeleteTitle(String noun) {
    return 'Delete $noun';
  }

  @override
  String ldDeleteBody(String noun) {
    return 'Are you sure you want to permanently delete this $noun';
  }

  @override
  String get ldNevermind => 'Nevermind';

  @override
  String get ldYesDelete => 'Yes, Delete';

  @override
  String ldDeactivateTitle(String noun) {
    return 'Deactivate $noun';
  }

  @override
  String ldDeactivateBody(String noun) {
    return 'Are you sure you want to temporarily deactivate this $noun';
  }

  @override
  String get ldDeactivationPeriod => 'Deactivation Period';

  @override
  String get ldSelectDuration => 'Select duration';

  @override
  String get ldSelectDurationTitle => 'Select Duration';

  @override
  String get ld1Week => '1 week';

  @override
  String get ld2Weeks => '2 weeks';

  @override
  String get ld1Month => '1 month';

  @override
  String get ld3Months => '3 months';

  @override
  String get ldYesDeactivate => 'Yes, Deactivate';

  @override
  String get done => 'Done';

  @override
  String elUpdateTitle(String label) {
    return 'Update $label';
  }

  @override
  String get elServiceSubtitle => 'Update this service for your business';

  @override
  String get elProductSubtitle =>
      'Update your product and increase your stock count';

  @override
  String get elPhotoComingSoon => 'Photo upload coming soon';

  @override
  String get elSelectSizes => 'Select Sizes';

  @override
  String get elForSale => 'For sale';

  @override
  String get elForRent => 'For rent';

  @override
  String get elProductType => 'Product type 📦';

  @override
  String get elSelectType => 'Select type';

  @override
  String get elProductTypeSheet => 'Product Type';

  @override
  String get elSizes => 'Sizes ';

  @override
  String get elOptional => '(optional)';

  @override
  String get elSelectSizesPlaceholder => 'Select sizes';

  @override
  String get elRentalDuration => 'Rental Duration';

  @override
  String get elSkuHint => 'Enter SKU...';

  @override
  String get elMainPhoto => 'Main Photo';

  @override
  String get elSecondPhoto => 'Second Photo';

  @override
  String get elThirdPhoto => 'Third Photo';

  @override
  String get elFourthPhoto => 'Fourth Photo';

  @override
  String get elUpdatedSuccess => 'Listing updated successfully';

  @override
  String get trackingTitle => 'Order Tracking';

  @override
  String get trackingComingSoon => 'Order tracking is coming soon';

  @override
  String get trackingComingSoonBody =>
      'Delivery and rental tracking will appear here once it’s available.';

  @override
  String get reviewClientFallback => 'Client';

  @override
  String get reviewTitle => 'Review';

  @override
  String reviewSubtitle(String name) {
    return 'Let us know how your experience was with $name';
  }

  @override
  String get reviewFeedbackLabel => 'Leave a Detailed feedback';

  @override
  String get reviewFeedbackHint => 'Let us know how your experience was';

  @override
  String get reviewSubmitted => 'Review submitted!';

  @override
  String get reviewSendReview => 'Send Review';

  @override
  String get cancelBookingTitle => 'Cancel Booking';

  @override
  String get coReason1 => 'Client was rude';

  @override
  String get coReason2 => 'Event was more than described';

  @override
  String get coReason3 => 'The Client was late to the event';

  @override
  String get coReason4 => 'Client Refused to Pay the second installment';

  @override
  String get coReason5 => 'Other issue';

  @override
  String get coNotice =>
      'Our team mediates all disputes. We aim to resolve within 48 hours. Try messaging the client first — most issues are resolved quickly.';

  @override
  String get coReasonTitle => 'Reason for Cancelling Booking';

  @override
  String get coDescribeIssue => 'Describe the issue';

  @override
  String get coDescribeHint =>
      'Describe what happened in detail, include dates, amounts, and any relevant context';

  @override
  String get coAttachEvidence => 'Attach evidence (optional)';

  @override
  String get coUploadImage => 'Upload Image';

  @override
  String get coBookingCancelled => 'Booking cancelled';

  @override
  String get coCancelOrder => 'Cancel Order';

  @override
  String get coMessageClient => 'Message Client Instead';

  @override
  String get msgTitle => 'Messages';

  @override
  String get msgSubtitle => 'Stay connected with your clients';

  @override
  String get msgSearchHint => 'Search conversations';

  @override
  String get msgNoConversations => 'No conversations found';

  @override
  String msgParticipants(int count) {
    return '$count participants';
  }

  @override
  String get convConfirmed => 'Confirmed';

  @override
  String get convDeclined => 'Declined';

  @override
  String get convQuoteExpired => 'Quote expired';

  @override
  String convDepositRefundedAmt(String amount) {
    return 'Deposit refunded · ₦$amount';
  }

  @override
  String get convDepositRefunded => 'Deposit refunded';

  @override
  String convPaymentReceivedAmt(String amount) {
    return 'Payment received · ₦$amount';
  }

  @override
  String get convPaymentReceived => 'Payment received';

  @override
  String get convOrderUpdate => 'Order update';

  @override
  String get convReviewRequested => 'Review requested';

  @override
  String convReviewLeftRating(String rating) {
    return 'Client left a review · $rating★';
  }

  @override
  String get convReviewLeft => 'Client left a review';

  @override
  String get convBankBanner =>
      'Quote accepted — add your bank account to get paid.';

  @override
  String get convAdd => 'Add';

  @override
  String get convConfirmReturn => 'Confirm return';

  @override
  String get convMarkDelivered => 'Mark delivered';

  @override
  String get convPostUpdate => 'Post update';

  @override
  String get convConfirmReturnTitle => 'Confirm rental return?';

  @override
  String get convConfirmReturnBody =>
      'This completes the rental and refunds the client\'s deposit. Send the deposit back to the client from your bank.';

  @override
  String get convRentalCompleted => 'Rental completed — deposit refunded 🎉';

  @override
  String get convPostUpdateTitle => 'Post an update';

  @override
  String get convPostUpdateHint => 'e.g. Out for delivery — arriving by 4pm';

  @override
  String get convPost => 'Post';

  @override
  String get convUpdatePosted => 'Update posted';

  @override
  String get convMarkDeliveredTitle => 'Mark as delivered?';

  @override
  String get convMarkDeliveredBody =>
      'This completes the booking and asks the client to leave a review.';

  @override
  String get convMarkedDelivered => 'Marked as delivered 🎉';

  @override
  String get convReviseQuote => 'Revise quote';

  @override
  String get convCreateSendQuote => 'Create & send quote';

  @override
  String get convOrderAccepted => 'Order accepted — invoice sent 🎉';

  @override
  String get convOrderDeclined => 'Order declined';

  @override
  String get convCouldNotIdentifyClient => 'Could not identify the client';

  @override
  String get convCouldNotUpdateTask => 'Couldn\'t update the task';

  @override
  String get convCouldNotLoadListings => 'Could not load your listings';

  @override
  String get convAddListingFirst => 'Add a listing first to send a quote';

  @override
  String get convQuoteForListing => 'Quote for which listing?';

  @override
  String get convTypeMessage => 'Type a message';

  @override
  String get cqAddLineItem => 'Add at least one line item with an amount';

  @override
  String get cqRevisedSent => 'Revised quote sent 🎉';

  @override
  String get cqQuoteSent => 'Quote sent to the client 🎉';

  @override
  String get cqOpenFromChat =>
      'Open this from a client chat or inquiry to send a quote';

  @override
  String get cqValidForTitle => 'Quote valid for';

  @override
  String get cqTitleCreate => 'Create quote';

  @override
  String get cqEvent => 'Event';

  @override
  String get cqDescription => 'Description';

  @override
  String get cqAmount => 'Amount';

  @override
  String get cqAddItem => '+ Add Item';

  @override
  String cqSubtotal(String amount) {
    return 'Subtotal $amount';
  }

  @override
  String cqMilestone(int number) {
    return 'Milestone $number';
  }

  @override
  String get cqLineItems => 'Line Items';

  @override
  String get cqSetPaymentTerms => 'Payment Terms (optional)';

  @override
  String get cqPaymentTermsHint =>
      'e.g. 50% deposit, balance on delivery — paid directly';

  @override
  String get cqNoteToClient => 'Note to client';

  @override
  String get cqNoteHint => 'Short description of the product';

  @override
  String get cqSending => 'Sending…';

  @override
  String get cqSendRevised => 'Send revised quote';

  @override
  String get cqCreateQuote => 'Create Quote';

  @override
  String get cqDueOnConfirmation => 'Due on booking confirmation (immediately)';

  @override
  String get cqTermPayAtOnce => 'Pay at once';

  @override
  String get cqTermCustom => 'Custom';

  @override
  String get cqValid1Day => '1 Day';

  @override
  String get cqValid3Days => '3 Days';

  @override
  String get cqValid7Days => '7 Days';

  @override
  String get cqValid14Days => '14 Days';

  @override
  String get cqValid30Days => '30 Days';

  @override
  String get ciTitle => 'Create invoice';

  @override
  String get ciInvoiceItems => 'Invoice Items';

  @override
  String get ciPaymentMilestones => 'Payment Milestones';

  @override
  String get ciFromQuote => 'From Quote';

  @override
  String get ciBanner =>
      'Pre-filled from accepted quote QT-2026-047. Review items and payment milestones, then send to confirm the booking.';

  @override
  String get ciPayoutToAccount => 'Payout to your account';

  @override
  String get ciAccount => 'Account';

  @override
  String get ciYourPayout => 'Your payout';

  @override
  String ciSendInvoiceTo(String name) {
    return 'Send Invoice to $name';
  }

  @override
  String get ciInvoiceSent => 'Invoice sent successfully!';

  @override
  String get ciPreview => 'Preview';

  @override
  String get profileYourBusiness => 'Your business';

  @override
  String profilePlanLabel(String tier) {
    return '$tier Plan';
  }

  @override
  String get profileVerified => 'Verified';

  @override
  String get profileUnverified => 'Unverified';

  @override
  String get profileGeneral => 'General';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileUpdateProfile => 'Update your Profile';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileReviews => 'Reviews';

  @override
  String get profileLinkedBanks => 'Linked Bank accounts';

  @override
  String get profileGallery => 'Gallery';

  @override
  String get profileSubscriptionPlans => 'Subscription Plans';

  @override
  String get profileLanguagePref => 'Language Preference';

  @override
  String get profileTheme => 'Theme';

  @override
  String get profileCustomizeStorefront => 'Customize your Storefront';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileHelpSupport => 'Help and Support';

  @override
  String get profileTerms => 'Terms & Conditions';

  @override
  String get profileLeavePlanovar => 'Leave Planovar';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String psUploadLogoFailed(String error) {
    return 'Could not upload logo: $error';
  }

  @override
  String psUploadCoverFailed(String error) {
    return 'Could not upload cover: $error';
  }

  @override
  String get psProfileUpdated => 'Profile updated';

  @override
  String get psEmailAddress => 'Email Address';

  @override
  String get psEmailHint => 'Email address';

  @override
  String get psPhoneNumber => 'Phone Number';

  @override
  String get psPhoneHint => 'Phone number';

  @override
  String get psDateOfBirth => 'Date of Birth';

  @override
  String get psUpdateDetails => 'Update Details';

  @override
  String get psAddCoverPhoto => 'Add cover photo';

  @override
  String get psStorefrontHint =>
      'Your logo and cover are what clients see on your storefront.';

  @override
  String get psStorefrontImages => 'Storefront images';

  @override
  String get psBusinessName => 'Business Name';

  @override
  String get psBusinessNameHint => 'Business name';

  @override
  String get psBusinessType => 'Business Type';

  @override
  String get psBizLicensed => 'Licensed Business';

  @override
  String get psBizFreelancer => 'Freelancer';

  @override
  String get psBusinessDescription => 'Business Description';

  @override
  String get psBusinessDescHint => 'Short description of your business';

  @override
  String get psCategoryTags => 'Category Tags';

  @override
  String get psEditProfile => 'Edit your Profile';

  @override
  String get psPersonalDetails => 'Personal Details';

  @override
  String get psBusinessDetails => 'Business Details';

  @override
  String get psMonthJan => 'January';

  @override
  String get psMonthFeb => 'February';

  @override
  String get psMonthMar => 'March';

  @override
  String get psMonthApr => 'April';

  @override
  String get psMonthMay => 'May';

  @override
  String get psMonthJun => 'June';

  @override
  String get psMonthJul => 'July';

  @override
  String get psMonthAug => 'August';

  @override
  String get psMonthSep => 'September';

  @override
  String get psMonthOct => 'October';

  @override
  String get psMonthNov => 'November';

  @override
  String get psMonthDec => 'December';

  @override
  String get psSecurity => 'Security';

  @override
  String get psChangePassword => 'Change Password';

  @override
  String get psChangePasswordSub => 'Update your login password.';

  @override
  String get ps2faTitle => '2FA Authentication';

  @override
  String get ps2faSub => 'Add an extra layer of security.';

  @override
  String get psNewPassword => 'New Password';

  @override
  String get psNewPasswordHint => 'Enter new password';

  @override
  String get psConfirmPassword => 'Confirm Password';

  @override
  String get psConfirmPasswordHint => 'Confirm new password';

  @override
  String get psReqCapital => 'Should have a Capital Letter';

  @override
  String get psReqNumber => 'Should have a Number e.g 1,2,4,etc';

  @override
  String get psReqSpecial => 'Should have a Special Character e.g @,\$,%,etc';

  @override
  String get psSavePassword => 'Save Password';

  @override
  String get psPasswordSaved => 'Password saved';

  @override
  String get psTheme => 'Theme';

  @override
  String get psSelectDisplay => 'Select your preferred display';

  @override
  String get psThemeLight => 'Light';

  @override
  String get psThemeDark => 'Dark';

  @override
  String get psThemeSystem => 'System';

  @override
  String get psSavePreference => 'Save Preference';

  @override
  String get psThemeSaved => 'Theme preference saved';

  @override
  String get psNotification => 'Notification';

  @override
  String get psChannelNone => 'None';

  @override
  String get psChannelInApp => 'In app';

  @override
  String get psChannelEmail => 'Email';

  @override
  String get psChannelBoth => 'Both';

  @override
  String get psAllNotifications => 'All notifications';

  @override
  String get psChooseWhere => 'Chose where you want to receive notifications';

  @override
  String get psNotifAllMessages => 'All messages';

  @override
  String get psNotifAllMessagesSub => 'someone replies your message';

  @override
  String get psNotifOrderDelivery => 'Order/ Delivery Timeline';

  @override
  String get psNotifOrderDeliverySub =>
      'get notified when an order is received / completed';

  @override
  String get psNotifEventTimeline => 'Event Timeline';

  @override
  String get psNotifEventTimelineSub =>
      'get notified when there\'s a new event timeline';

  @override
  String get psNotifPayment => 'Payment alerts';

  @override
  String get psNotifPaymentSub => 'get notified when a payment is successful';

  @override
  String get psNotifQuoteInvoice => 'Quote / Invoice alerts';

  @override
  String get psNotifQuoteInvoiceSub =>
      'get notified when your quote is acted on';

  @override
  String get psLinkedBankAccount => 'Linked Bank Account';

  @override
  String get psWhereClientsPay => 'Where clients pay you directly';

  @override
  String get psAddBankAccount => 'Add bank account';

  @override
  String get psChangeBankAccount => 'Change bank account';

  @override
  String get psNoBankYet => 'No bank account yet';

  @override
  String get psNoBankBody =>
      'Add one so clients can pay you directly when they accept your quotes.';

  @override
  String get psBankFallback => 'Bank';

  @override
  String get psReadyToReceive => 'Ready to receive payments';

  @override
  String get psSettingUp => 'Setting up…';

  @override
  String get psReasonNoNeed => 'I no longer need the service';

  @override
  String get psReasonBetter => 'I found a better platform';

  @override
  String get psReasonTech => 'Too many technical issues';

  @override
  String get psReasonPrivacy => 'Privacy concerns';

  @override
  String get psReasonOther => 'Other';

  @override
  String get psSelectReason => 'Select a Reason';

  @override
  String get psDeleteConfirmTitle => 'Are you sure you want delete';

  @override
  String get psDeleteBullet1 => 'Access to your active Bookings';

  @override
  String get psDeleteBullet2 =>
      'Access to your account records and credentials';

  @override
  String get psDeleteBullet3 => 'Login details';

  @override
  String get psDeleteBullet4 => 'All Client contacts via message and call';

  @override
  String get psYesConfirm => 'Yes, Confirm';

  @override
  String get psNotYet => 'Not Yet';

  @override
  String get psSuccessful => 'Successful';

  @override
  String get psDeleteSuccessBody =>
      'Your account has been deleted successfully. We\'re sorry to see you go and we hope to see you soon';

  @override
  String get psCloseApp => 'Close App';

  @override
  String get psDeleteAccount => 'Delete Account';

  @override
  String get psYourAccount => 'Your account';

  @override
  String get psTellReason => 'Tell us the reason for deleting your account';

  @override
  String get psSelectOption => 'Select an Option';

  @override
  String get psOtherReasons => 'Other Reasons';

  @override
  String get psTypeMessage => 'Type your message';

  @override
  String get psDeactivateAccount => 'Deactivate Account';

  @override
  String get psAccountDeactivated => 'Account deactivated';

  @override
  String psTrialStarted(String name) {
    return 'Your $name free trial has started 🎉';
  }

  @override
  String psNowOnPlan(String name) {
    return 'You are now on the $name plan';
  }

  @override
  String get psPaymentCancelled => 'Payment cancelled — your plan is unchanged';

  @override
  String psPaymentConfirmed(String name) {
    return 'Payment confirmed — you are now on the $name plan';
  }

  @override
  String get psSubscriptionPlan => 'Subscription Plan';

  @override
  String get psChoosePlan =>
      'Choose the plan that fits your business. Upgrade or switch anytime.';

  @override
  String get psOnTrial => 'On trial';

  @override
  String get psCurrent => 'Current';

  @override
  String psSwitchTo(String name) {
    return 'Switch to $name';
  }

  @override
  String psUpgradeTo(String name) {
    return 'Upgrade to $name';
  }

  @override
  String reviewsReplyTo(String name) {
    return 'Reply to $name';
  }

  @override
  String get reviewsReplyHint => 'Thank them, or address their feedback…';

  @override
  String get reviewsSending => 'Sending…';

  @override
  String get reviewsSendReply => 'Send reply';

  @override
  String get reviewsMyReviews => 'My Reviews';

  @override
  String get reviewsSubtitle => 'Reviews you\'ve received from your past work';

  @override
  String get reviewsLoadFailed => 'Could not load reviews';

  @override
  String get reviewsEmpty => 'No reviews yet';

  @override
  String get reviewsEmptyBody =>
      'Complete bookings and your client reviews will appear here.';

  @override
  String reviewsCount(int total) {
    return '($total Reviews)';
  }

  @override
  String reviewsMonthsAgo(int count) {
    return '${count}mo ago';
  }

  @override
  String reviewsDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String reviewsHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get reviewsJustNow => 'just now';

  @override
  String get reviewsReply => 'Reply';

  @override
  String get reviewsYourReply => 'Your reply';

  @override
  String get termsRowTitle => 'Terms and Conditions';

  @override
  String get termsLastUpdated => 'Last updated 17th April 2025';

  @override
  String get termsPrivacyPolicy => 'Privacy Policy';

  @override
  String get termsPrivacySubtitle => 'Read our privacy agreement';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get galleryPhoto1 => 'Front Photo';

  @override
  String get galleryPhoto2 => 'Second Photo';

  @override
  String get galleryPhoto3 => 'Third Photo';

  @override
  String get galleryPhoto4 => 'Fourth Photo';

  @override
  String galleryUploadFailed(String error) {
    return 'Could not upload photo: $error';
  }

  @override
  String get gallerySaved => 'Gallery saved';

  @override
  String gallerySaveFailed(String error) {
    return 'Could not save gallery: $error';
  }

  @override
  String get gallerySubtitle => 'Showcase your best work to attract clients';

  @override
  String get gallerySaveButton => 'Save Gallery';

  @override
  String get supportTitle => 'Support';

  @override
  String supportGreeting(String name) {
    return 'Hey, $name 👋';
  }

  @override
  String get supportThere => 'there';

  @override
  String get supportSearchHint => 'How can we help you?';

  @override
  String get supportPromoTitle => 'Top-Notch support system';

  @override
  String get supportPromoSub => 'Get quick responses with our online chat';

  @override
  String get supportFaqTitle => 'Frequently Asked Questions';

  @override
  String get supportViewMore => 'View More Questions';

  @override
  String get supportChat => 'Chat';

  @override
  String get supportChatSub => 'Need help? We are here for you';

  @override
  String get supportCallSupport => 'Call Support';

  @override
  String get supportCallHours => 'Available Mon - Fri, 9am - 5pm';

  @override
  String get supportFaqQ1 => 'How do I create a listing?';

  @override
  String get supportFaqQ2 => 'How do I manage bookings?';

  @override
  String get supportFaqQ3 => 'How do clients pay for my services?';

  @override
  String get supportFaqQ4 => 'How do I withdraw my earnings?';

  @override
  String get supportFaqQ5 => 'What fees does Planovar charge?';

  @override
  String get supportFaqQ6 => 'How do I verify my account?';

  @override
  String get supportFaqQ7 => 'Can I cancel a booking?';

  @override
  String get supportFaqQ8 => 'How do reviews work?';

  @override
  String get supportFaqQ9 => 'How do I upgrade my subscription?';

  @override
  String get supportFaqQ10 => 'How do I contact a client?';

  @override
  String supportQuestionN(int number) {
    return 'Question $number';
  }

  @override
  String get supportNeedMoreHelp => 'I need more help';

  @override
  String get supportChatWithUs => 'Chat with us';

  @override
  String get supportCallUs => 'Call Us';

  @override
  String get supportCallAvailable =>
      'We\'re available from Monday- Friday from 9am - 5pm';

  @override
  String get supportLiveSupport => 'Live Support';

  @override
  String get supportReplyMinutes => 'We usually reply in a few minutes';

  @override
  String get supportChatSetup => 'Live chat is being set up';

  @override
  String get supportChatSetupMsg =>
      'Our live chat isn\'t connected yet. In the meantime, email us and we\'ll get right back to you.';

  @override
  String get supportEmailSupport => 'Email support';

  @override
  String get supportChatTeam => 'Chat with our team';

  @override
  String get supportChatTeamMsg =>
      'Open our live chat to talk to a support agent.';

  @override
  String get supportOpenChat => 'Open live chat';

  @override
  String get twofaIntroTitle => 'Enable 2FA for additional security';

  @override
  String get twofaGetStarted => 'Get Started';

  @override
  String get twofaSetupTitle => '2FA Setup';

  @override
  String get twofaSetUpUsing => 'Set up using';

  @override
  String get twofaAuthenticatorHint =>
      'Using the authenticator app such as (Google Authenticator, Authy, 1Password, Last pass etc';

  @override
  String get twofaScanMe => 'Scan Me';

  @override
  String get twofaCantScan =>
      'If you can\'t scan the QR code above, enter this text instead';

  @override
  String get twofaConfirmCode => 'Confirm Code';

  @override
  String get twofaEnterCode =>
      'Enter the code provided by the authenticator app';

  @override
  String get twofaConfirm => 'Confirm';

  @override
  String get twofaAllPrefix => 'All ';

  @override
  String get twofaDoneWord => 'done';

  @override
  String get twofaSuccessBody => 'Your 2FA has been successfully enabled';

  @override
  String get twofaBackToProfile => 'Back to profile setup';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsActiveListings => 'Active Listings';

  @override
  String analyticsOfTotal(int total) {
    return 'of $total total';
  }

  @override
  String get analyticsInquiries => 'Inquiries';

  @override
  String analyticsAwaitingReply(int count) {
    return '$count awaiting reply';
  }

  @override
  String get analyticsRating => 'Rating';

  @override
  String analyticsReviews(int count) {
    return '$count reviews';
  }

  @override
  String get analyticsPlan => 'Plan';

  @override
  String get analyticsDetailedTitle => 'Detailed performance analytics';

  @override
  String get analyticsComingSoon =>
      'Trends, profile views and conversion charts are coming soon.';

  @override
  String get payoutsTitle => 'Payments';

  @override
  String get payoutsHeadline => 'You keep 100% of what you earn';

  @override
  String get payoutsBody =>
      'Planovar runs on a subscription — we don’t hold your money or take a commission. Clients pay you directly, the way you both agree.';

  @override
  String get notifMarkAllRead => 'Mark all read';

  @override
  String get notifEmpty => 'No notifications';

  @override
  String get notifFilterAll => 'All';

  @override
  String get notifFilterOrders => 'Orders';

  @override
  String get notifFilterPayments => 'Payments';

  @override
  String get notifFilterSystem => 'System';

  @override
  String get notifToday => 'Today';

  @override
  String get notifYesterday => 'Yesterday';

  @override
  String get notifEarlier => 'Earlier';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusDeclined => 'Declined';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusFeatured => 'Featured';

  @override
  String get statusPremium => 'Premium';

  @override
  String get statusBasic => 'Basic';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusSuperseded => 'Superseded';

  @override
  String get statusPartiallyPaid => 'Partially paid';

  @override
  String get ccQuote => 'Quote';

  @override
  String ccValidTill(String date) {
    return 'Valid till $date';
  }

  @override
  String get ccTotal => 'Total';

  @override
  String ccInvoiceNumber(String number) {
    return 'Invoice · $number';
  }

  @override
  String get ccOrderRequest => 'Order request';

  @override
  String get ccClientRequesting =>
      'Client is requesting this — accept to send an invoice';

  @override
  String get ccDecline => 'Decline';

  @override
  String get ccAccept => 'Accept';

  @override
  String ccDue(String date) {
    return 'Due $date';
  }

  @override
  String get ccTaskDone => 'You completed your task';

  @override
  String get ccMarkTaskDone => 'Mark your task done';

  @override
  String get errorSomethingWrong => 'Something went wrong';

  @override
  String get errorTryAgain => 'Try Again';

  @override
  String get bankAdded =>
      'Bank account added — you can now receive payments 🎉';

  @override
  String get bankClientsPayDirect =>
      'Clients pay you directly to this account.';

  @override
  String get bankLoading => 'Loading banks…';

  @override
  String get bankSelect => 'Select bank';

  @override
  String get bankAccountNumberHint => '10-digit account number';

  @override
  String get bankVerifying => 'Verifying account…';

  @override
  String get bankSaving => 'Saving…';

  @override
  String get bankSaveAccount => 'Save account';

  @override
  String get bankSearch => 'Search bank';

  @override
  String get planPopular => 'POPULAR';

  @override
  String get planCurrentPlan => 'Current plan';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planYearly => 'Yearly';

  @override
  String get qrcNew => 'New';

  @override
  String qrcBudget(String amount) {
    return 'Budget: $amount';
  }

  @override
  String get qrcBudgetTbd => 'Budget: TBD';

  @override
  String get qrcOpenRespond => 'Open & Respond';

  @override
  String get qrcReject => 'Reject';

  @override
  String get tagAddMore => 'Add tag...';

  @override
  String tagHelper(int count, int max) {
    return 'Press comma or Enter to add a tag  ·  $count/$max';
  }

  @override
  String get psCurrentPassword => 'Current Password';

  @override
  String get psCurrentPasswordHint => 'Enter your current password';

  @override
  String get psCurrentPasswordRequired => 'Please enter your current password';

  @override
  String get psPasswordTooWeak =>
      'Your new password must be at least 8 characters and include an uppercase letter, a number, and a special character';

  @override
  String get psPasswordsDontMatch => 'The new passwords don\'t match';

  @override
  String get tfaChallengeTitle => 'Two-Factor Authentication';

  @override
  String get tfaChallengeSubtitle =>
      'Enter the 6-digit code from your authenticator app';

  @override
  String get tfaVerify => 'Verify';

  @override
  String get twofaDisable => 'Disable Two-Factor';

  @override
  String get twofaConfirmPasswordTitle => 'Confirm your password';

  @override
  String get twofaContinue => 'Continue';

  @override
  String get twofaDisabled => 'Two-factor authentication disabled';

  @override
  String get twofaSecretCopied => 'Setup key copied';

  @override
  String get twofaBackupCodesTitle => 'Backup codes';

  @override
  String get twofaBackupCodesHint =>
      'Save these somewhere safe — each can be used once if you lose your authenticator.';

  @override
  String get cqAfterEvent => 'After the event';
}
