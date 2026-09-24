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
}
