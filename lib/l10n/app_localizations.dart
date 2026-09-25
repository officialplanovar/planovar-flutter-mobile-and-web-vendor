import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language. English is available now — more are on the way.'**
  String get languageIntro;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoon;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navListings.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get navListings;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your Journey on Planovar'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email address'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

  /// No description provided for @noAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have an account?'**
  String get noAccountQuestion;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Unlock thousands of event clients'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Connect with couples, corporates, and event planners in your location, all actively searching for vendors like you'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Manage Everything in one Dashboard'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Track your inquiries, bookings, and conversations from a single workspace'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Showcase your work, get discovered'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'List your products, services and rentals — then subscribe to climb search rankings and reach event planners first.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingListBusiness.
  ///
  /// In en, this message translates to:
  /// **'List my business'**
  String get onboardingListBusiness;

  /// No description provided for @onboardingHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onboardingHaveAccount;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your vendor account'**
  String get loginSubtitle;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'yourname@business.com'**
  String get emailPlaceholder;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your vendor account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start listing your business on Planovar'**
  String get registerSubtitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ada'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Obi'**
  String get lastNameHint;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @businessNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sugared Dreams Cakery'**
  String get businessNameHint;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dobPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'DD / MM / YYYY'**
  String get dobPlaceholder;

  /// No description provided for @selectDob.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectDob;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'8012345678'**
  String get phoneNumberHint;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters'**
  String get createPasswordHint;

  /// No description provided for @registerAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'By checking the box you agree to our '**
  String get registerAgreePrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @registerAgreeAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get registerAgreeAnd;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInAction;

  /// No description provided for @forgotResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotResetTitle;

  /// No description provided for @forgotResetIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a 6-digit code to reset your password.'**
  String get forgotResetIntro;

  /// No description provided for @forgotResetSentTo.
  ///
  /// In en, this message translates to:
  /// **'A reset code has been sent to {email}. Check your inbox.'**
  String forgotResetSentTo(String email);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get sendResetCode;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please sign in.'**
  String get resetPasswordSuccess;

  /// No description provided for @resetCreateNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get resetCreateNewPassword;

  /// No description provided for @resetCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to '**
  String get resetCodeSentTo;

  /// No description provided for @resetChoosePassword.
  ///
  /// In en, this message translates to:
  /// **' and choose a new password.'**
  String get resetChoosePassword;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @sixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get sixDigitCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @atLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Chars;

  /// No description provided for @mustBeAtLeast8Chars.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get mustBeAtLeast8Chars;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailIntro.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit OTP to your email'**
  String get verifyEmailIntro;

  /// No description provided for @verifyNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent'**
  String get verifyNewCodeSent;

  /// No description provided for @verifyCouldNotResend.
  ///
  /// In en, this message translates to:
  /// **'Could not resend code: {error}'**
  String verifyCouldNotResend(String error);

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @verifyResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String verifyResendIn(int seconds);

  /// No description provided for @resendCodeAction.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCodeAction;

  /// No description provided for @setupBusinessSetup.
  ///
  /// In en, this message translates to:
  /// **'Business Setup'**
  String get setupBusinessSetup;

  /// No description provided for @setupBusinessProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get setupBusinessProfileTitle;

  /// No description provided for @setupBusinessProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell clients who you are'**
  String get setupBusinessProfileSubtitle;

  /// No description provided for @setupLicensedBusiness.
  ///
  /// In en, this message translates to:
  /// **'Licensed Business'**
  String get setupLicensedBusiness;

  /// No description provided for @setupLicensedBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Registered company, agency or studio'**
  String get setupLicensedBusinessDesc;

  /// No description provided for @setupFreelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get setupFreelancer;

  /// No description provided for @setupFreelancerDesc.
  ///
  /// In en, this message translates to:
  /// **'Individual offering professional services'**
  String get setupFreelancerDesc;

  /// No description provided for @setupCouldNotLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories'**
  String get setupCouldNotLoadCategories;

  /// No description provided for @setupCouldNotReadFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file'**
  String get setupCouldNotReadFile;

  /// No description provided for @setupFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is larger than 5 MB'**
  String get setupFileTooLarge;

  /// No description provided for @setupBusinessLogoOptional.
  ///
  /// In en, this message translates to:
  /// **'Business logo (optional)'**
  String get setupBusinessLogoOptional;

  /// No description provided for @setupBusinessDescription.
  ///
  /// In en, this message translates to:
  /// **'Business Description'**
  String get setupBusinessDescription;

  /// No description provided for @setupBusinessDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell clients what makes your business special, your experience, and what you offer...'**
  String get setupBusinessDescriptionHint;

  /// No description provided for @setupProofOfOwnership.
  ///
  /// In en, this message translates to:
  /// **'Proof of Ownership'**
  String get setupProofOfOwnership;

  /// No description provided for @setupProofOptionalFreelancers.
  ///
  /// In en, this message translates to:
  /// **'(optional for freelancers)'**
  String get setupProofOptionalFreelancers;

  /// No description provided for @setupDocumentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded'**
  String get setupDocumentUploaded;

  /// No description provided for @setupTapToReplace.
  ///
  /// In en, this message translates to:
  /// **'Tap to replace'**
  String get setupTapToReplace;

  /// No description provided for @setupTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get setupTapToUpload;

  /// No description provided for @setupUploadFileTypes.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or PDF up to 5mb'**
  String get setupUploadFileTypes;

  /// No description provided for @setupCategoryTags.
  ///
  /// In en, this message translates to:
  /// **'Category tags'**
  String get setupCategoryTags;

  /// No description provided for @setupNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available yet'**
  String get setupNoCategories;

  /// No description provided for @setupLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location & reach'**
  String get setupLocationTitle;

  /// No description provided for @setupLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you operate?'**
  String get setupLocationSubtitle;

  /// No description provided for @setupTurnOnLocation.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services to use this.'**
  String get setupTurnOnLocation;

  /// No description provided for @setupLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied — pick your city manually.'**
  String get setupLocationDenied;

  /// No description provided for @setupCouldNotDetermineCity.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t determine your city — please pick it manually.'**
  String get setupCouldNotDetermineCity;

  /// No description provided for @setupCouldNotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Please pick your city manually.'**
  String get setupCouldNotGetLocation;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @selectYourCity.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectYourCity;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @setupLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get setupLocating;

  /// No description provided for @setupUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get setupUseCurrentLocation;

  /// No description provided for @setupVendorType.
  ///
  /// In en, this message translates to:
  /// **'Vendor type'**
  String get setupVendorType;

  /// No description provided for @setupProductsOnly.
  ///
  /// In en, this message translates to:
  /// **'Products Only'**
  String get setupProductsOnly;

  /// No description provided for @setupServicesOnly.
  ///
  /// In en, this message translates to:
  /// **'Services only'**
  String get setupServicesOnly;

  /// No description provided for @setupBothProductsServices.
  ///
  /// In en, this message translates to:
  /// **'Both products & services'**
  String get setupBothProductsServices;

  /// No description provided for @setupChoosePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get setupChoosePlanTitle;

  /// No description provided for @setupChoosePlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade anytime. Cancel anytime.'**
  String get setupChoosePlanSubtitle;

  /// No description provided for @setupCouldNotLoadPlans.
  ///
  /// In en, this message translates to:
  /// **'Could not load plans. Check your connection and try again.'**
  String get setupCouldNotLoadPlans;

  /// No description provided for @setupSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'Select {plan}'**
  String setupSelectPlan(String plan);

  /// No description provided for @setupSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get setupSkipForNow;

  /// No description provided for @setupVerifyIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity'**
  String get setupVerifyIdentityTitle;

  /// No description provided for @setupVerifyIdentitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your NIN, and CAC if you run a licensed business. Stored securely.'**
  String get setupVerifyIdentitySubtitle;

  /// No description provided for @setupUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get setupUploaded;

  /// No description provided for @setupUploadNin.
  ///
  /// In en, this message translates to:
  /// **'Upload your NIN slip'**
  String get setupUploadNin;

  /// No description provided for @setupUploadCac.
  ///
  /// In en, this message translates to:
  /// **'Upload your CAC document'**
  String get setupUploadCac;

  /// No description provided for @setupPaymentNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment not completed — you can subscribe to a paid plan anytime from your profile.'**
  String get setupPaymentNotCompleted;

  /// No description provided for @setupSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get setupSomethingWentWrong;

  /// No description provided for @setupSettingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up…'**
  String get setupSettingUp;

  /// No description provided for @setupFinishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get setupFinishSetup;

  /// No description provided for @setupCompleteVerificationLater.
  ///
  /// In en, this message translates to:
  /// **'You can complete verification later from your profile.'**
  String get setupCompleteVerificationLater;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @setupPayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout details'**
  String get setupPayoutTitle;

  /// No description provided for @setupPayoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where should we send your earnings?'**
  String get setupPayoutSubtitle;

  /// No description provided for @setupBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get setupBankName;

  /// No description provided for @setupSelectYourBank.
  ///
  /// In en, this message translates to:
  /// **'Select your bank'**
  String get setupSelectYourBank;

  /// No description provided for @setupAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get setupAccountNumber;

  /// No description provided for @setupAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'0123456789'**
  String get setupAccountNumberHint;

  /// No description provided for @setupAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get setupAccountName;

  /// No description provided for @setupAutoVerified.
  ///
  /// In en, this message translates to:
  /// **'Auto verified'**
  String get setupAutoVerified;

  /// No description provided for @setupPayoutSchedule.
  ///
  /// In en, this message translates to:
  /// **'Payout schedule'**
  String get setupPayoutSchedule;

  /// No description provided for @setupPayoutRolling.
  ///
  /// In en, this message translates to:
  /// **'Rolling · 24–48hrs after completion'**
  String get setupPayoutRolling;

  /// No description provided for @setupPayoutCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform commission · Deducted before payout'**
  String get setupPayoutCommission;

  /// No description provided for @setupMinimumPayout.
  ///
  /// In en, this message translates to:
  /// **'Minimum payout · ₦1,000'**
  String get setupMinimumPayout;

  /// No description provided for @setupSecuredByPaystack.
  ///
  /// In en, this message translates to:
  /// **'Secured by Paystack'**
  String get setupSecuredByPaystack;

  /// No description provided for @setupSavePayoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Payout Details'**
  String get setupSavePayoutDetails;

  /// No description provided for @setupAllSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get setupAllSet;

  /// No description provided for @setupProfileLive.
  ///
  /// In en, this message translates to:
  /// **'Your vendor profile is live on Planovar. Start adding your products and services to reach thousands of event planners in Lagos.'**
  String get setupProfileLive;

  /// No description provided for @setupAddFirstListing.
  ///
  /// In en, this message translates to:
  /// **'Add your first listing'**
  String get setupAddFirstListing;

  /// No description provided for @setupAddFirstListingSub.
  ///
  /// In en, this message translates to:
  /// **'Products, services or rentals'**
  String get setupAddFirstListingSub;

  /// No description provided for @setupUpgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your plan'**
  String get setupUpgradePlan;

  /// No description provided for @setupUpgradePlanSub.
  ///
  /// In en, this message translates to:
  /// **'Get more visibility & analytics'**
  String get setupUpgradePlanSub;

  /// No description provided for @setupGoToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get setupGoToDashboard;

  /// No description provided for @payCompletePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete payment'**
  String get payCompletePayment;

  /// No description provided for @paySecurePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get paySecurePayment;

  /// No description provided for @payBrowserFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open your browser. Tap below to open the secure Paystack checkout.'**
  String get payBrowserFailed;

  /// No description provided for @payBrowserOpened.
  ///
  /// In en, this message translates to:
  /// **'We\'ve opened the secure Paystack checkout in your browser. Finish your payment there, then come back and tap the button below.'**
  String get payBrowserOpened;

  /// No description provided for @payOpenPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Open payment page'**
  String get payOpenPaymentPage;

  /// No description provided for @payReopenPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Reopen payment page'**
  String get payReopenPaymentPage;

  /// No description provided for @payCompletedPayment.
  ///
  /// In en, this message translates to:
  /// **'I\'ve completed payment'**
  String get payCompletedPayment;

  /// No description provided for @homeTodaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get homeTodaysSchedule;

  /// No description provided for @homeQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick Action'**
  String get homeQuickAction;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @homeNewRequestsAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} New requests need your attention'**
  String homeNewRequestsAttention(int count);

  /// No description provided for @homeNewRequestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have {count} new requests for your listings'**
  String homeNewRequestsSubtitle(int count);

  /// No description provided for @homeConfirmedBookings.
  ///
  /// In en, this message translates to:
  /// **'Confirmed Bookings'**
  String get homeConfirmedBookings;

  /// No description provided for @homePendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get homePendingRequests;

  /// No description provided for @homeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get homeThisMonth;

  /// No description provided for @homeBookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bookings'**
  String homeBookingsCount(int count);

  /// No description provided for @homeAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get homeAvgRating;

  /// No description provided for @homeFromReviews.
  ///
  /// In en, this message translates to:
  /// **'from {count} reviews'**
  String homeFromReviews(int count);

  /// No description provided for @homeNoSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule for today'**
  String get homeNoSchedule;

  /// No description provided for @homeAddListing.
  ///
  /// In en, this message translates to:
  /// **'Add Listing'**
  String get homeAddListing;

  /// No description provided for @homeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get homeAnalytics;

  /// No description provided for @homeUpgradePlanShort.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get homeUpgradePlanShort;

  /// No description provided for @homePayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get homePayouts;

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get homeGoodMorning;

  /// No description provided for @homeGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get homeGoodAfternoon;

  /// No description provided for @homeGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get homeGoodEvening;

  /// No description provided for @listingTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing Type'**
  String get listingTypeTitle;

  /// No description provided for @listingTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the type of listing you want to create'**
  String get listingTypeSubtitle;

  /// No description provided for @listingTypeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get listingTypeService;

  /// No description provided for @listingTypeServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'bookable appointment'**
  String get listingTypeServiceDesc;

  /// No description provided for @listingTypeProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get listingTypeProduct;

  /// No description provided for @listingTypeProductDesc.
  ///
  /// In en, this message translates to:
  /// **'Physical item for rent or sale'**
  String get listingTypeProductDesc;

  /// No description provided for @homeActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action Needed'**
  String get homeActionNeeded;

  /// No description provided for @homeAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up'**
  String get homeAllCaughtUp;

  /// No description provided for @homeNoInquiriesWaiting.
  ///
  /// In en, this message translates to:
  /// **'No inquiries are waiting on your response.'**
  String get homeNoInquiriesWaiting;

  /// No description provided for @homeNewInquiry.
  ///
  /// In en, this message translates to:
  /// **'New inquiry'**
  String get homeNewInquiry;

  /// No description provided for @homeNewBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get homeNewBadge;

  /// No description provided for @homeOpenRespond.
  ///
  /// In en, this message translates to:
  /// **'Open & Respond'**
  String get homeOpenRespond;

  /// No description provided for @addListingNewListing.
  ///
  /// In en, this message translates to:
  /// **'New Listing'**
  String get addListingNewListing;

  /// No description provided for @addListingServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Bookable appointment'**
  String get addListingServiceDesc;

  /// No description provided for @addSuccessSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get addSuccessSuccessfully;

  /// No description provided for @addSuccessAddedTitle.
  ///
  /// In en, this message translates to:
  /// **'{label} Added '**
  String addSuccessAddedTitle(String label);

  /// No description provided for @addSuccessPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your {label} has been saved. It will become visible to clients once your account is verified.'**
  String addSuccessPendingSubtitle(String label);

  /// No description provided for @addSuccessLiveService.
  ///
  /// In en, this message translates to:
  /// **'Your service has been added successfully and is currently Live'**
  String get addSuccessLiveService;

  /// No description provided for @addSuccessLiveProduct.
  ///
  /// In en, this message translates to:
  /// **'Your product has been added successfully and is currently Live'**
  String get addSuccessLiveProduct;

  /// No description provided for @addSuccessPendingWarning.
  ///
  /// In en, this message translates to:
  /// **'Pending verification — clients can\'t see your listings until an admin verifies your account. We\'ll let you know once you\'re approved.'**
  String get addSuccessPendingWarning;

  /// No description provided for @addSuccessIdLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} ID'**
  String addSuccessIdLabel(String label);

  /// No description provided for @addSuccessSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get addSuccessSku;

  /// No description provided for @addSuccessDateCreated.
  ///
  /// In en, this message translates to:
  /// **'Date Created'**
  String get addSuccessDateCreated;

  /// No description provided for @addSuccessViewLabel.
  ///
  /// In en, this message translates to:
  /// **'View {label}'**
  String addSuccessViewLabel(String label);

  /// No description provided for @listingBadgeProductRental.
  ///
  /// In en, this message translates to:
  /// **'Product (Rental)'**
  String get listingBadgeProductRental;

  /// No description provided for @listingPerDay.
  ///
  /// In en, this message translates to:
  /// **'{price} / day'**
  String listingPerDay(String price);

  /// No description provided for @listingQuoteBased.
  ///
  /// In en, this message translates to:
  /// **'Quote based'**
  String get listingQuoteBased;

  /// No description provided for @listingsMyListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get listingsMyListings;

  /// No description provided for @listingsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String listingsTabAll(int count);

  /// No description provided for @listingsTabServices.
  ///
  /// In en, this message translates to:
  /// **'Services ({count})'**
  String listingsTabServices(int count);

  /// No description provided for @listingsTabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products ({count})'**
  String listingsTabProducts(int count);

  /// No description provided for @listingsTabRentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals ({count})'**
  String listingsTabRentals(int count);

  /// No description provided for @listingsOutOfStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Items are out of Stock, '**
  String listingsOutOfStockCount(int count);

  /// No description provided for @listingsClickToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Click to update'**
  String get listingsClickToUpdate;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @listingsPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get listingsPendingReview;

  /// No description provided for @listingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No listings here yet'**
  String get listingsEmptyTitle;

  /// No description provided for @listingsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first listing'**
  String get listingsEmptySubtitle;

  /// No description provided for @listingsAddListing.
  ///
  /// In en, this message translates to:
  /// **'Add listing'**
  String get listingsAddListing;

  /// No description provided for @listingsCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load your listings'**
  String get listingsCouldNotLoad;

  /// No description provided for @oosTitle.
  ///
  /// In en, this message translates to:
  /// **'Listings out of stock'**
  String get oosTitle;

  /// No description provided for @oosRental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get oosRental;

  /// No description provided for @oosReactivated.
  ///
  /// In en, this message translates to:
  /// **'{noun} reactivated'**
  String oosReactivated(String noun);

  /// No description provided for @oosBadge.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get oosBadge;

  /// No description provided for @oosRestock.
  ///
  /// In en, this message translates to:
  /// **'Re stock'**
  String get oosRestock;

  /// No description provided for @oosEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'All listings are in stock!'**
  String get oosEmptyTitle;

  /// No description provided for @oosEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No out-of-stock items in this category'**
  String get oosEmptySubtitle;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @apGenerateSkuHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the product name first, then generate an SKU.'**
  String get apGenerateSkuHint;

  /// No description provided for @apNameDescRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name and description are required'**
  String get apNameDescRequired;

  /// No description provided for @apSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get apSelectCategory;

  /// No description provided for @apSelectACategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get apSelectACategory;

  /// No description provided for @apNoCategoriesProfile.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any categories to your profile yet. Add them under Profile → Business Details to list products here.'**
  String get apNoCategoriesProfile;

  /// No description provided for @apOnlyRegisteredCategories.
  ///
  /// In en, this message translates to:
  /// **'Only your registered categories are shown. Add more in Profile → Business Details.'**
  String get apOnlyRegisteredCategories;

  /// No description provided for @apForSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get apForSale;

  /// No description provided for @apForRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get apForRent;

  /// No description provided for @apTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Product'**
  String get apTitle;

  /// No description provided for @apSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a product to your catalogue'**
  String get apSubtitle;

  /// No description provided for @apProductName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get apProductName;

  /// No description provided for @apProductNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product name...'**
  String get apProductNameHint;

  /// No description provided for @apProductDescription.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get apProductDescription;

  /// No description provided for @apProductDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your product...'**
  String get apProductDescriptionHint;

  /// No description provided for @apProductPrice.
  ///
  /// In en, this message translates to:
  /// **'Product Price'**
  String get apProductPrice;

  /// No description provided for @apPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price Per Day'**
  String get apPricePerDay;

  /// No description provided for @apRefundableDeposit.
  ///
  /// In en, this message translates to:
  /// **'Refundable Deposit'**
  String get apRefundableDeposit;

  /// No description provided for @apRentalDuration.
  ///
  /// In en, this message translates to:
  /// **'Rental Duration (days)'**
  String get apRentalDuration;

  /// No description provided for @apRentalDurationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3'**
  String get apRentalDurationHint;

  /// No description provided for @apSkuHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product SKU...'**
  String get apSkuHint;

  /// No description provided for @apGenerateForMe.
  ///
  /// In en, this message translates to:
  /// **'Generate for me'**
  String get apGenerateForMe;

  /// No description provided for @apQuantityInStock.
  ///
  /// In en, this message translates to:
  /// **'Quantity in Stock'**
  String get apQuantityInStock;

  /// No description provided for @apQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'How many do you have in stock'**
  String get apQuantityHint;

  /// No description provided for @apAvailableSizes.
  ///
  /// In en, this message translates to:
  /// **'Available Sizes (Optional)'**
  String get apAvailableSizes;

  /// No description provided for @apTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get apTags;

  /// No description provided for @apTagsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wedding, Cake, Luxury'**
  String get apTagsHint;

  /// No description provided for @apProductPhotos.
  ///
  /// In en, this message translates to:
  /// **'Product Photos'**
  String get apProductPhotos;

  /// No description provided for @apFrontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Front Photo'**
  String get apFrontPhoto;

  /// No description provided for @apBackPhoto.
  ///
  /// In en, this message translates to:
  /// **'Back Photo'**
  String get apBackPhoto;

  /// No description provided for @apSidePhoto.
  ///
  /// In en, this message translates to:
  /// **'Side Photo'**
  String get apSidePhoto;

  /// No description provided for @apDetailPhoto.
  ///
  /// In en, this message translates to:
  /// **'Detail Photo'**
  String get apDetailPhoto;

  /// No description provided for @apPublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get apPublishing;

  /// No description provided for @apPublishProduct.
  ///
  /// In en, this message translates to:
  /// **'Publish Product'**
  String get apPublishProduct;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @asNameDescRequired.
  ///
  /// In en, this message translates to:
  /// **'Service name and description are required'**
  String get asNameDescRequired;

  /// No description provided for @asNoCategoriesProfile.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any categories to your profile yet. Add them under Profile → Business Details to list services here.'**
  String get asNoCategoriesProfile;

  /// No description provided for @asCancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get asCancellationPolicy;

  /// No description provided for @policyFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get policyFlexible;

  /// No description provided for @policyModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get policyModerate;

  /// No description provided for @policyStrict.
  ///
  /// In en, this message translates to:
  /// **'Strict'**
  String get policyStrict;

  /// No description provided for @policyFlexibleDesc.
  ///
  /// In en, this message translates to:
  /// **'Full refund if the client cancels up to 24 hours before the event.'**
  String get policyFlexibleDesc;

  /// No description provided for @policyModerateDesc.
  ///
  /// In en, this message translates to:
  /// **'50% refund if cancelled at least 7 days before the event; none after.'**
  String get policyModerateDesc;

  /// No description provided for @policyStrictDesc.
  ///
  /// In en, this message translates to:
  /// **'No refund once the booking is confirmed.'**
  String get policyStrictDesc;

  /// No description provided for @asCategoryInfo.
  ///
  /// In en, this message translates to:
  /// **'The service category clients browse by. Only the categories you registered on your profile appear here.'**
  String get asCategoryInfo;

  /// No description provided for @asPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get asPriceRange;

  /// No description provided for @asPriceRangeInfo.
  ///
  /// In en, this message translates to:
  /// **'The typical price band for this service. Clients see it as a guide; the final amount is agreed in your quote.'**
  String get asPriceRangeInfo;

  /// No description provided for @asMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get asMin;

  /// No description provided for @asMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get asMax;

  /// No description provided for @asServiceDuration.
  ///
  /// In en, this message translates to:
  /// **'Service Duration'**
  String get asServiceDuration;

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get durationDays;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get durationHours;

  /// No description provided for @durationMins.
  ///
  /// In en, this message translates to:
  /// **'Mins'**
  String get durationMins;

  /// No description provided for @asDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter duration value...'**
  String get asDurationHint;

  /// No description provided for @asSelectPolicy.
  ///
  /// In en, this message translates to:
  /// **'Select a policy'**
  String get asSelectPolicy;

  /// No description provided for @asCancellationPolicyInfo.
  ///
  /// In en, this message translates to:
  /// **'How refunds work if a client cancels. Choose the level that best fits your business.'**
  String get asCancellationPolicyInfo;

  /// No description provided for @asTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Service'**
  String get asTitle;

  /// No description provided for @asSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a service for your business'**
  String get asSubtitle;

  /// No description provided for @asServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get asServiceName;

  /// No description provided for @asServiceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter service name...'**
  String get asServiceNameHint;

  /// No description provided for @asServiceNameInfo.
  ///
  /// In en, this message translates to:
  /// **'A short, clear name clients will see, e.g. \"Wedding Photography — Full Day\".'**
  String get asServiceNameInfo;

  /// No description provided for @asServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get asServiceDescription;

  /// No description provided for @asServiceDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your service...'**
  String get asServiceDescriptionHint;

  /// No description provided for @asServiceDescriptionInfo.
  ///
  /// In en, this message translates to:
  /// **'What\'s included, your experience, and what clients can expect. The more detail, the more trust.'**
  String get asServiceDescriptionInfo;

  /// No description provided for @asTagsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wedding, Photography, Outdoor'**
  String get asTagsHint;

  /// No description provided for @asServicePhotos.
  ///
  /// In en, this message translates to:
  /// **'Service Photos'**
  String get asServicePhotos;

  /// No description provided for @asPhotoNumber.
  ///
  /// In en, this message translates to:
  /// **'Photo {number}'**
  String asPhotoNumber(int number);

  /// No description provided for @asPublishService.
  ///
  /// In en, this message translates to:
  /// **'Publish Service'**
  String get asPublishService;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @ldNotFound.
  ///
  /// In en, this message translates to:
  /// **'Listing not found'**
  String get ldNotFound;

  /// No description provided for @ldServiceLower.
  ///
  /// In en, this message translates to:
  /// **'service'**
  String get ldServiceLower;

  /// No description provided for @ldProductLower.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get ldProductLower;

  /// No description provided for @ldDeleted.
  ///
  /// In en, this message translates to:
  /// **'{noun} deleted'**
  String ldDeleted(String noun);

  /// No description provided for @ldDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{noun} deactivated'**
  String ldDeactivated(String noun);

  /// No description provided for @ldEditService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get ldEditService;

  /// No description provided for @ldEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get ldEditProduct;

  /// No description provided for @ldDeleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get ldDeleteService;

  /// No description provided for @ldDeleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get ldDeleteProduct;

  /// No description provided for @ldDeactivateService.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Service'**
  String get ldDeactivateService;

  /// No description provided for @ldDeactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get ldDeactivateProduct;

  /// No description provided for @ldViews30d.
  ///
  /// In en, this message translates to:
  /// **'Views (30d)'**
  String get ldViews30d;

  /// No description provided for @ldRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ldRating;

  /// No description provided for @ldNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get ldNoReviews;

  /// No description provided for @ldFixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed price'**
  String get ldFixedPrice;

  /// No description provided for @ldStartingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get ldStartingFrom;

  /// No description provided for @ldQuoteOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Quote on request'**
  String get ldQuoteOnRequest;

  /// No description provided for @ldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get ldType;

  /// No description provided for @ldPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price per day'**
  String get ldPricePerDay;

  /// No description provided for @ldStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get ldStock;

  /// No description provided for @ldCancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get ldCancellationPolicy;

  /// No description provided for @ldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get ldPrice;

  /// No description provided for @ldFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String ldFrom(String price);

  /// No description provided for @ldPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get ldPricing;

  /// No description provided for @ldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get ldDuration;

  /// No description provided for @ldInStock.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String ldInStock(int count);

  /// No description provided for @ldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ldStatus;

  /// No description provided for @ldListed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get ldListed;

  /// No description provided for @ldDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {noun}'**
  String ldDeleteTitle(String noun);

  /// No description provided for @ldDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this {noun}'**
  String ldDeleteBody(String noun);

  /// No description provided for @ldNevermind.
  ///
  /// In en, this message translates to:
  /// **'Nevermind'**
  String get ldNevermind;

  /// No description provided for @ldYesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get ldYesDelete;

  /// No description provided for @ldDeactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {noun}'**
  String ldDeactivateTitle(String noun);

  /// No description provided for @ldDeactivateBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to temporarily deactivate this {noun}'**
  String ldDeactivateBody(String noun);

  /// No description provided for @ldDeactivationPeriod.
  ///
  /// In en, this message translates to:
  /// **'Deactivation Period'**
  String get ldDeactivationPeriod;

  /// No description provided for @ldSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get ldSelectDuration;

  /// No description provided for @ldSelectDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get ldSelectDurationTitle;

  /// No description provided for @ld1Week.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get ld1Week;

  /// No description provided for @ld2Weeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get ld2Weeks;

  /// No description provided for @ld1Month.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get ld1Month;

  /// No description provided for @ld3Months.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get ld3Months;

  /// No description provided for @ldYesDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Yes, Deactivate'**
  String get ldYesDeactivate;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @elUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update {label}'**
  String elUpdateTitle(String label);

  /// No description provided for @elServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this service for your business'**
  String get elServiceSubtitle;

  /// No description provided for @elProductSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your product and increase your stock count'**
  String get elProductSubtitle;

  /// No description provided for @elPhotoComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Photo upload coming soon'**
  String get elPhotoComingSoon;

  /// No description provided for @elSelectSizes.
  ///
  /// In en, this message translates to:
  /// **'Select Sizes'**
  String get elSelectSizes;

  /// No description provided for @elForSale.
  ///
  /// In en, this message translates to:
  /// **'For sale'**
  String get elForSale;

  /// No description provided for @elForRent.
  ///
  /// In en, this message translates to:
  /// **'For rent'**
  String get elForRent;

  /// No description provided for @elProductType.
  ///
  /// In en, this message translates to:
  /// **'Product type 📦'**
  String get elProductType;

  /// No description provided for @elSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get elSelectType;

  /// No description provided for @elProductTypeSheet.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get elProductTypeSheet;

  /// No description provided for @elSizes.
  ///
  /// In en, this message translates to:
  /// **'Sizes '**
  String get elSizes;

  /// No description provided for @elOptional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get elOptional;

  /// No description provided for @elSelectSizesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select sizes'**
  String get elSelectSizesPlaceholder;

  /// No description provided for @elRentalDuration.
  ///
  /// In en, this message translates to:
  /// **'Rental Duration'**
  String get elRentalDuration;

  /// No description provided for @elSkuHint.
  ///
  /// In en, this message translates to:
  /// **'Enter SKU...'**
  String get elSkuHint;

  /// No description provided for @elMainPhoto.
  ///
  /// In en, this message translates to:
  /// **'Main Photo'**
  String get elMainPhoto;

  /// No description provided for @elSecondPhoto.
  ///
  /// In en, this message translates to:
  /// **'Second Photo'**
  String get elSecondPhoto;

  /// No description provided for @elThirdPhoto.
  ///
  /// In en, this message translates to:
  /// **'Third Photo'**
  String get elThirdPhoto;

  /// No description provided for @elFourthPhoto.
  ///
  /// In en, this message translates to:
  /// **'Fourth Photo'**
  String get elFourthPhoto;

  /// No description provided for @elUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing updated successfully'**
  String get elUpdatedSuccess;

  /// No description provided for @trackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Tracking'**
  String get trackingTitle;

  /// No description provided for @trackingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Order tracking is coming soon'**
  String get trackingComingSoon;

  /// No description provided for @trackingComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Delivery and rental tracking will appear here once it’s available.'**
  String get trackingComingSoonBody;

  /// No description provided for @reviewClientFallback.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get reviewClientFallback;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @reviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let us know how your experience was with {name}'**
  String reviewSubtitle(String name);

  /// No description provided for @reviewFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Leave a Detailed feedback'**
  String get reviewFeedbackLabel;

  /// No description provided for @reviewFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Let us know how your experience was'**
  String get reviewFeedbackHint;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted!'**
  String get reviewSubmitted;

  /// No description provided for @reviewSendReview.
  ///
  /// In en, this message translates to:
  /// **'Send Review'**
  String get reviewSendReview;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBookingTitle;

  /// No description provided for @coReason1.
  ///
  /// In en, this message translates to:
  /// **'Client was rude'**
  String get coReason1;

  /// No description provided for @coReason2.
  ///
  /// In en, this message translates to:
  /// **'Event was more than described'**
  String get coReason2;

  /// No description provided for @coReason3.
  ///
  /// In en, this message translates to:
  /// **'The Client was late to the event'**
  String get coReason3;

  /// No description provided for @coReason4.
  ///
  /// In en, this message translates to:
  /// **'Client Refused to Pay the second installment'**
  String get coReason4;

  /// No description provided for @coReason5.
  ///
  /// In en, this message translates to:
  /// **'Other issue'**
  String get coReason5;

  /// No description provided for @coNotice.
  ///
  /// In en, this message translates to:
  /// **'Our team mediates all disputes. We aim to resolve within 48 hours. Try messaging the client first — most issues are resolved quickly.'**
  String get coNotice;

  /// No description provided for @coReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Reason for Cancelling Booking'**
  String get coReasonTitle;

  /// No description provided for @coDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get coDescribeIssue;

  /// No description provided for @coDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened in detail, include dates, amounts, and any relevant context'**
  String get coDescribeHint;

  /// No description provided for @coAttachEvidence.
  ///
  /// In en, this message translates to:
  /// **'Attach evidence (optional)'**
  String get coAttachEvidence;

  /// No description provided for @coUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get coUploadImage;

  /// No description provided for @coBookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get coBookingCancelled;

  /// No description provided for @coCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get coCancelOrder;

  /// No description provided for @coMessageClient.
  ///
  /// In en, this message translates to:
  /// **'Message Client Instead'**
  String get coMessageClient;

  /// No description provided for @msgTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get msgTitle;

  /// No description provided for @msgSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your clients'**
  String get msgSubtitle;

  /// No description provided for @msgSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search conversations'**
  String get msgSearchHint;

  /// No description provided for @msgNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations found'**
  String get msgNoConversations;

  /// No description provided for @msgParticipants.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String msgParticipants(int count);

  /// No description provided for @convConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get convConfirmed;

  /// No description provided for @convDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get convDeclined;

  /// No description provided for @convQuoteExpired.
  ///
  /// In en, this message translates to:
  /// **'Quote expired'**
  String get convQuoteExpired;

  /// No description provided for @convDepositRefundedAmt.
  ///
  /// In en, this message translates to:
  /// **'Deposit refunded · ₦{amount}'**
  String convDepositRefundedAmt(String amount);

  /// No description provided for @convDepositRefunded.
  ///
  /// In en, this message translates to:
  /// **'Deposit refunded'**
  String get convDepositRefunded;

  /// No description provided for @convPaymentReceivedAmt.
  ///
  /// In en, this message translates to:
  /// **'Payment received · ₦{amount}'**
  String convPaymentReceivedAmt(String amount);

  /// No description provided for @convPaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get convPaymentReceived;

  /// No description provided for @convOrderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order update'**
  String get convOrderUpdate;

  /// No description provided for @convReviewRequested.
  ///
  /// In en, this message translates to:
  /// **'Review requested'**
  String get convReviewRequested;

  /// No description provided for @convReviewLeftRating.
  ///
  /// In en, this message translates to:
  /// **'Client left a review · {rating}★'**
  String convReviewLeftRating(String rating);

  /// No description provided for @convReviewLeft.
  ///
  /// In en, this message translates to:
  /// **'Client left a review'**
  String get convReviewLeft;

  /// No description provided for @convBankBanner.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted — add your bank account to get paid.'**
  String get convBankBanner;

  /// No description provided for @convAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get convAdd;

  /// No description provided for @convConfirmReturn.
  ///
  /// In en, this message translates to:
  /// **'Confirm return'**
  String get convConfirmReturn;

  /// No description provided for @convMarkDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark delivered'**
  String get convMarkDelivered;

  /// No description provided for @convPostUpdate.
  ///
  /// In en, this message translates to:
  /// **'Post update'**
  String get convPostUpdate;

  /// No description provided for @convConfirmReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm rental return?'**
  String get convConfirmReturnTitle;

  /// No description provided for @convConfirmReturnBody.
  ///
  /// In en, this message translates to:
  /// **'This completes the rental and refunds the client\'s deposit. Send the deposit back to the client from your bank.'**
  String get convConfirmReturnBody;

  /// No description provided for @convRentalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Rental completed — deposit refunded 🎉'**
  String get convRentalCompleted;

  /// No description provided for @convPostUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Post an update'**
  String get convPostUpdateTitle;

  /// No description provided for @convPostUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Out for delivery — arriving by 4pm'**
  String get convPostUpdateHint;

  /// No description provided for @convPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get convPost;

  /// No description provided for @convUpdatePosted.
  ///
  /// In en, this message translates to:
  /// **'Update posted'**
  String get convUpdatePosted;

  /// No description provided for @convMarkDeliveredTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as delivered?'**
  String get convMarkDeliveredTitle;

  /// No description provided for @convMarkDeliveredBody.
  ///
  /// In en, this message translates to:
  /// **'This completes the booking and asks the client to leave a review.'**
  String get convMarkDeliveredBody;

  /// No description provided for @convMarkedDelivered.
  ///
  /// In en, this message translates to:
  /// **'Marked as delivered 🎉'**
  String get convMarkedDelivered;

  /// No description provided for @convReviseQuote.
  ///
  /// In en, this message translates to:
  /// **'Revise quote'**
  String get convReviseQuote;

  /// No description provided for @convCreateSendQuote.
  ///
  /// In en, this message translates to:
  /// **'Create & send quote'**
  String get convCreateSendQuote;

  /// No description provided for @convOrderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted — invoice sent 🎉'**
  String get convOrderAccepted;

  /// No description provided for @convOrderDeclined.
  ///
  /// In en, this message translates to:
  /// **'Order declined'**
  String get convOrderDeclined;

  /// No description provided for @convCouldNotIdentifyClient.
  ///
  /// In en, this message translates to:
  /// **'Could not identify the client'**
  String get convCouldNotIdentifyClient;

  /// No description provided for @convCouldNotUpdateTask.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the task'**
  String get convCouldNotUpdateTask;

  /// No description provided for @convCouldNotLoadListings.
  ///
  /// In en, this message translates to:
  /// **'Could not load your listings'**
  String get convCouldNotLoadListings;

  /// No description provided for @convAddListingFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a listing first to send a quote'**
  String get convAddListingFirst;

  /// No description provided for @convQuoteForListing.
  ///
  /// In en, this message translates to:
  /// **'Quote for which listing?'**
  String get convQuoteForListing;

  /// No description provided for @convTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get convTypeMessage;

  /// No description provided for @cqAddLineItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one line item with an amount'**
  String get cqAddLineItem;

  /// No description provided for @cqRevisedSent.
  ///
  /// In en, this message translates to:
  /// **'Revised quote sent 🎉'**
  String get cqRevisedSent;

  /// No description provided for @cqQuoteSent.
  ///
  /// In en, this message translates to:
  /// **'Quote sent to the client 🎉'**
  String get cqQuoteSent;

  /// No description provided for @cqOpenFromChat.
  ///
  /// In en, this message translates to:
  /// **'Open this from a client chat or inquiry to send a quote'**
  String get cqOpenFromChat;

  /// No description provided for @cqValidForTitle.
  ///
  /// In en, this message translates to:
  /// **'Quote valid for'**
  String get cqValidForTitle;

  /// No description provided for @cqTitleCreate.
  ///
  /// In en, this message translates to:
  /// **'Create quote'**
  String get cqTitleCreate;

  /// No description provided for @cqEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get cqEvent;

  /// No description provided for @cqDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get cqDescription;

  /// No description provided for @cqAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get cqAmount;

  /// No description provided for @cqAddItem.
  ///
  /// In en, this message translates to:
  /// **'+ Add Item'**
  String get cqAddItem;

  /// No description provided for @cqSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal {amount}'**
  String cqSubtotal(String amount);

  /// No description provided for @cqMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone {number}'**
  String cqMilestone(int number);

  /// No description provided for @cqLineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get cqLineItems;

  /// No description provided for @cqSetPaymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Set your Payment Terms'**
  String get cqSetPaymentTerms;

  /// No description provided for @cqNoteToClient.
  ///
  /// In en, this message translates to:
  /// **'Note to client'**
  String get cqNoteToClient;

  /// No description provided for @cqNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Short description of the product'**
  String get cqNoteHint;

  /// No description provided for @cqSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get cqSending;

  /// No description provided for @cqSendRevised.
  ///
  /// In en, this message translates to:
  /// **'Send revised quote'**
  String get cqSendRevised;

  /// No description provided for @cqCreateQuote.
  ///
  /// In en, this message translates to:
  /// **'Create Quote'**
  String get cqCreateQuote;

  /// No description provided for @cqDueOnConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Due on booking confirmation (immediately)'**
  String get cqDueOnConfirmation;

  /// No description provided for @cqTermPayAtOnce.
  ///
  /// In en, this message translates to:
  /// **'Pay at once'**
  String get cqTermPayAtOnce;

  /// No description provided for @cqTermCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get cqTermCustom;

  /// No description provided for @cqValid1Day.
  ///
  /// In en, this message translates to:
  /// **'1 Day'**
  String get cqValid1Day;

  /// No description provided for @cqValid3Days.
  ///
  /// In en, this message translates to:
  /// **'3 Days'**
  String get cqValid3Days;

  /// No description provided for @cqValid7Days.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get cqValid7Days;

  /// No description provided for @cqValid14Days.
  ///
  /// In en, this message translates to:
  /// **'14 Days'**
  String get cqValid14Days;

  /// No description provided for @cqValid30Days.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get cqValid30Days;

  /// No description provided for @ciTitle.
  ///
  /// In en, this message translates to:
  /// **'Create invoice'**
  String get ciTitle;

  /// No description provided for @ciInvoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get ciInvoiceItems;

  /// No description provided for @ciPaymentMilestones.
  ///
  /// In en, this message translates to:
  /// **'Payment Milestones'**
  String get ciPaymentMilestones;

  /// No description provided for @ciFromQuote.
  ///
  /// In en, this message translates to:
  /// **'From Quote'**
  String get ciFromQuote;

  /// No description provided for @ciBanner.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled from accepted quote QT-2026-047. Review items and payment milestones, then send to confirm the booking.'**
  String get ciBanner;

  /// No description provided for @ciPayoutToAccount.
  ///
  /// In en, this message translates to:
  /// **'Payout to your account'**
  String get ciPayoutToAccount;

  /// No description provided for @ciAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get ciAccount;

  /// No description provided for @ciYourPayout.
  ///
  /// In en, this message translates to:
  /// **'Your payout'**
  String get ciYourPayout;

  /// No description provided for @ciSendInvoiceTo.
  ///
  /// In en, this message translates to:
  /// **'Send Invoice to {name}'**
  String ciSendInvoiceTo(String name);

  /// No description provided for @ciInvoiceSent.
  ///
  /// In en, this message translates to:
  /// **'Invoice sent successfully!'**
  String get ciInvoiceSent;

  /// No description provided for @ciPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get ciPreview;

  /// No description provided for @profileYourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Your business'**
  String get profileYourBusiness;

  /// No description provided for @profilePlanLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier} Plan'**
  String profilePlanLabel(String tier);

  /// No description provided for @profileVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileVerified;

  /// No description provided for @profileUnverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get profileUnverified;

  /// No description provided for @profileGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get profileGeneral;

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update your Profile'**
  String get profileUpdateProfile;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @profileReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get profileReviews;

  /// No description provided for @profileLinkedBanks.
  ///
  /// In en, this message translates to:
  /// **'Linked Bank accounts'**
  String get profileLinkedBanks;

  /// No description provided for @profileGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profileGallery;

  /// No description provided for @profileSubscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get profileSubscriptionPlans;

  /// No description provided for @profileLanguagePref.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get profileLanguagePref;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileTheme;

  /// No description provided for @profileCustomizeStorefront.
  ///
  /// In en, this message translates to:
  /// **'Customize your Storefront'**
  String get profileCustomizeStorefront;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get profileHelpSupport;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileTerms;

  /// No description provided for @profileLeavePlanovar.
  ///
  /// In en, this message translates to:
  /// **'Leave Planovar'**
  String get profileLeavePlanovar;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @psUploadLogoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload logo: {error}'**
  String psUploadLogoFailed(String error);

  /// No description provided for @psUploadCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload cover: {error}'**
  String psUploadCoverFailed(String error);

  /// No description provided for @psProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get psProfileUpdated;

  /// No description provided for @psEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get psEmailAddress;

  /// No description provided for @psEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get psEmailHint;

  /// No description provided for @psPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get psPhoneNumber;

  /// No description provided for @psPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get psPhoneHint;

  /// No description provided for @psDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get psDateOfBirth;

  /// No description provided for @psUpdateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Details'**
  String get psUpdateDetails;

  /// No description provided for @psAddCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add cover photo'**
  String get psAddCoverPhoto;

  /// No description provided for @psStorefrontHint.
  ///
  /// In en, this message translates to:
  /// **'Your logo and cover are what clients see on your storefront.'**
  String get psStorefrontHint;

  /// No description provided for @psStorefrontImages.
  ///
  /// In en, this message translates to:
  /// **'Storefront images'**
  String get psStorefrontImages;

  /// No description provided for @psBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get psBusinessName;

  /// No description provided for @psBusinessNameHint.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get psBusinessNameHint;

  /// No description provided for @psBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get psBusinessType;

  /// No description provided for @psBizLicensed.
  ///
  /// In en, this message translates to:
  /// **'Licensed Business'**
  String get psBizLicensed;

  /// No description provided for @psBizFreelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get psBizFreelancer;

  /// No description provided for @psBusinessDescription.
  ///
  /// In en, this message translates to:
  /// **'Business Description'**
  String get psBusinessDescription;

  /// No description provided for @psBusinessDescHint.
  ///
  /// In en, this message translates to:
  /// **'Short description of your business'**
  String get psBusinessDescHint;

  /// No description provided for @psCategoryTags.
  ///
  /// In en, this message translates to:
  /// **'Category Tags'**
  String get psCategoryTags;

  /// No description provided for @psEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit your Profile'**
  String get psEditProfile;

  /// No description provided for @psPersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get psPersonalDetails;

  /// No description provided for @psBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get psBusinessDetails;

  /// No description provided for @psMonthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get psMonthJan;

  /// No description provided for @psMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get psMonthFeb;

  /// No description provided for @psMonthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get psMonthMar;

  /// No description provided for @psMonthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get psMonthApr;

  /// No description provided for @psMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get psMonthMay;

  /// No description provided for @psMonthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get psMonthJun;

  /// No description provided for @psMonthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get psMonthJul;

  /// No description provided for @psMonthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get psMonthAug;

  /// No description provided for @psMonthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get psMonthSep;

  /// No description provided for @psMonthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get psMonthOct;

  /// No description provided for @psMonthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get psMonthNov;

  /// No description provided for @psMonthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get psMonthDec;

  /// No description provided for @psSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get psSecurity;

  /// No description provided for @psChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get psChangePassword;

  /// No description provided for @psChangePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Update your login password.'**
  String get psChangePasswordSub;

  /// No description provided for @ps2faTitle.
  ///
  /// In en, this message translates to:
  /// **'2FA Authentication'**
  String get ps2faTitle;

  /// No description provided for @ps2faSub.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security.'**
  String get ps2faSub;

  /// No description provided for @psNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get psNewPassword;

  /// No description provided for @psNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get psNewPasswordHint;

  /// No description provided for @psConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get psConfirmPassword;

  /// No description provided for @psConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get psConfirmPasswordHint;

  /// No description provided for @psReqCapital.
  ///
  /// In en, this message translates to:
  /// **'Should have a Capital Letter'**
  String get psReqCapital;

  /// No description provided for @psReqNumber.
  ///
  /// In en, this message translates to:
  /// **'Should have a Number e.g 1,2,4,etc'**
  String get psReqNumber;

  /// No description provided for @psReqSpecial.
  ///
  /// In en, this message translates to:
  /// **'Should have a Special Character e.g @,\$,%,etc'**
  String get psReqSpecial;

  /// No description provided for @psSavePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get psSavePassword;

  /// No description provided for @psPasswordSaved.
  ///
  /// In en, this message translates to:
  /// **'Password saved'**
  String get psPasswordSaved;

  /// No description provided for @psTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get psTheme;

  /// No description provided for @psSelectDisplay.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred display'**
  String get psSelectDisplay;

  /// No description provided for @psThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get psThemeLight;

  /// No description provided for @psThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get psThemeDark;

  /// No description provided for @psThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get psThemeSystem;

  /// No description provided for @psSavePreference.
  ///
  /// In en, this message translates to:
  /// **'Save Preference'**
  String get psSavePreference;

  /// No description provided for @psThemeSaved.
  ///
  /// In en, this message translates to:
  /// **'Theme preference saved'**
  String get psThemeSaved;

  /// No description provided for @psNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get psNotification;

  /// No description provided for @psChannelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get psChannelNone;

  /// No description provided for @psChannelInApp.
  ///
  /// In en, this message translates to:
  /// **'In app'**
  String get psChannelInApp;

  /// No description provided for @psChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get psChannelEmail;

  /// No description provided for @psChannelBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get psChannelBoth;

  /// No description provided for @psAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'All notifications'**
  String get psAllNotifications;

  /// No description provided for @psChooseWhere.
  ///
  /// In en, this message translates to:
  /// **'Chose where you want to receive notifications'**
  String get psChooseWhere;

  /// No description provided for @psNotifAllMessages.
  ///
  /// In en, this message translates to:
  /// **'All messages'**
  String get psNotifAllMessages;

  /// No description provided for @psNotifAllMessagesSub.
  ///
  /// In en, this message translates to:
  /// **'someone replies your message'**
  String get psNotifAllMessagesSub;

  /// No description provided for @psNotifOrderDelivery.
  ///
  /// In en, this message translates to:
  /// **'Order/ Delivery Timeline'**
  String get psNotifOrderDelivery;

  /// No description provided for @psNotifOrderDeliverySub.
  ///
  /// In en, this message translates to:
  /// **'get notified when an order is received / completed'**
  String get psNotifOrderDeliverySub;

  /// No description provided for @psNotifEventTimeline.
  ///
  /// In en, this message translates to:
  /// **'Event Timeline'**
  String get psNotifEventTimeline;

  /// No description provided for @psNotifEventTimelineSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when there\'s a new event timeline'**
  String get psNotifEventTimelineSub;

  /// No description provided for @psNotifPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment alerts'**
  String get psNotifPayment;

  /// No description provided for @psNotifPaymentSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when a payment is successful'**
  String get psNotifPaymentSub;

  /// No description provided for @psNotifQuoteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Quote / Invoice alerts'**
  String get psNotifQuoteInvoice;

  /// No description provided for @psNotifQuoteInvoiceSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when your quote is acted on'**
  String get psNotifQuoteInvoiceSub;

  /// No description provided for @psLinkedBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Linked Bank Account'**
  String get psLinkedBankAccount;

  /// No description provided for @psWhereClientsPay.
  ///
  /// In en, this message translates to:
  /// **'Where clients pay you directly'**
  String get psWhereClientsPay;

  /// No description provided for @psAddBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Add bank account'**
  String get psAddBankAccount;

  /// No description provided for @psChangeBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Change bank account'**
  String get psChangeBankAccount;

  /// No description provided for @psNoBankYet.
  ///
  /// In en, this message translates to:
  /// **'No bank account yet'**
  String get psNoBankYet;

  /// No description provided for @psNoBankBody.
  ///
  /// In en, this message translates to:
  /// **'Add one so clients can pay you directly when they accept your quotes.'**
  String get psNoBankBody;

  /// No description provided for @psBankFallback.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get psBankFallback;

  /// No description provided for @psReadyToReceive.
  ///
  /// In en, this message translates to:
  /// **'Ready to receive payments'**
  String get psReadyToReceive;

  /// No description provided for @psSettingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up…'**
  String get psSettingUp;

  /// No description provided for @psReasonNoNeed.
  ///
  /// In en, this message translates to:
  /// **'I no longer need the service'**
  String get psReasonNoNeed;

  /// No description provided for @psReasonBetter.
  ///
  /// In en, this message translates to:
  /// **'I found a better platform'**
  String get psReasonBetter;

  /// No description provided for @psReasonTech.
  ///
  /// In en, this message translates to:
  /// **'Too many technical issues'**
  String get psReasonTech;

  /// No description provided for @psReasonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy concerns'**
  String get psReasonPrivacy;

  /// No description provided for @psReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get psReasonOther;

  /// No description provided for @psSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Select a Reason'**
  String get psSelectReason;

  /// No description provided for @psDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want delete'**
  String get psDeleteConfirmTitle;

  /// No description provided for @psDeleteBullet1.
  ///
  /// In en, this message translates to:
  /// **'Access to your active Bookings'**
  String get psDeleteBullet1;

  /// No description provided for @psDeleteBullet2.
  ///
  /// In en, this message translates to:
  /// **'Access to your account records and credentials'**
  String get psDeleteBullet2;

  /// No description provided for @psDeleteBullet3.
  ///
  /// In en, this message translates to:
  /// **'Login details'**
  String get psDeleteBullet3;

  /// No description provided for @psDeleteBullet4.
  ///
  /// In en, this message translates to:
  /// **'All Client contacts via message and call'**
  String get psDeleteBullet4;

  /// No description provided for @psYesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Confirm'**
  String get psYesConfirm;

  /// No description provided for @psNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get psNotYet;

  /// No description provided for @psSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get psSuccessful;

  /// No description provided for @psDeleteSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully. We\'re sorry to see you go and we hope to see you soon'**
  String get psDeleteSuccessBody;

  /// No description provided for @psCloseApp.
  ///
  /// In en, this message translates to:
  /// **'Close App'**
  String get psCloseApp;

  /// No description provided for @psDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get psDeleteAccount;

  /// No description provided for @psYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get psYourAccount;

  /// No description provided for @psTellReason.
  ///
  /// In en, this message translates to:
  /// **'Tell us the reason for deleting your account'**
  String get psTellReason;

  /// No description provided for @psSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an Option'**
  String get psSelectOption;

  /// No description provided for @psOtherReasons.
  ///
  /// In en, this message translates to:
  /// **'Other Reasons'**
  String get psOtherReasons;

  /// No description provided for @psTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get psTypeMessage;

  /// No description provided for @psDeactivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get psDeactivateAccount;

  /// No description provided for @psAccountDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Account deactivated'**
  String get psAccountDeactivated;

  /// No description provided for @psTrialStarted.
  ///
  /// In en, this message translates to:
  /// **'Your {name} free trial has started 🎉'**
  String psTrialStarted(String name);

  /// No description provided for @psNowOnPlan.
  ///
  /// In en, this message translates to:
  /// **'You are now on the {name} plan'**
  String psNowOnPlan(String name);

  /// No description provided for @psPaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled — your plan is unchanged'**
  String get psPaymentCancelled;

  /// No description provided for @psPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed — you are now on the {name} plan'**
  String psPaymentConfirmed(String name);

  /// No description provided for @psSubscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get psSubscriptionPlan;

  /// No description provided for @psChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that fits your business. Upgrade or switch anytime.'**
  String get psChoosePlan;

  /// No description provided for @psOnTrial.
  ///
  /// In en, this message translates to:
  /// **'On trial'**
  String get psOnTrial;

  /// No description provided for @psCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get psCurrent;

  /// No description provided for @psSwitchTo.
  ///
  /// In en, this message translates to:
  /// **'Switch to {name}'**
  String psSwitchTo(String name);

  /// No description provided for @psUpgradeTo.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {name}'**
  String psUpgradeTo(String name);

  /// No description provided for @reviewsReplyTo.
  ///
  /// In en, this message translates to:
  /// **'Reply to {name}'**
  String reviewsReplyTo(String name);

  /// No description provided for @reviewsReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Thank them, or address their feedback…'**
  String get reviewsReplyHint;

  /// No description provided for @reviewsSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get reviewsSending;

  /// No description provided for @reviewsSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get reviewsSendReply;

  /// No description provided for @reviewsMyReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get reviewsMyReviews;

  /// No description provided for @reviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews you\'ve received from your past work'**
  String get reviewsSubtitle;

  /// No description provided for @reviewsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load reviews'**
  String get reviewsLoadFailed;

  /// No description provided for @reviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmpty;

  /// No description provided for @reviewsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete bookings and your client reviews will appear here.'**
  String get reviewsEmptyBody;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'({total} Reviews)'**
  String reviewsCount(int total);

  /// No description provided for @reviewsMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}mo ago'**
  String reviewsMonthsAgo(int count);

  /// No description provided for @reviewsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String reviewsDaysAgo(int count);

  /// No description provided for @reviewsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String reviewsHoursAgo(int count);

  /// No description provided for @reviewsJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get reviewsJustNow;

  /// No description provided for @reviewsReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reviewsReply;

  /// No description provided for @reviewsYourReply.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get reviewsYourReply;

  /// No description provided for @termsRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsRowTitle;

  /// No description provided for @termsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated 17th April 2025'**
  String get termsLastUpdated;

  /// No description provided for @termsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get termsPrivacyPolicy;

  /// No description provided for @termsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy agreement'**
  String get termsPrivacySubtitle;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @galleryPhoto1.
  ///
  /// In en, this message translates to:
  /// **'Front Photo'**
  String get galleryPhoto1;

  /// No description provided for @galleryPhoto2.
  ///
  /// In en, this message translates to:
  /// **'Second Photo'**
  String get galleryPhoto2;

  /// No description provided for @galleryPhoto3.
  ///
  /// In en, this message translates to:
  /// **'Third Photo'**
  String get galleryPhoto3;

  /// No description provided for @galleryPhoto4.
  ///
  /// In en, this message translates to:
  /// **'Fourth Photo'**
  String get galleryPhoto4;

  /// No description provided for @galleryUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload photo: {error}'**
  String galleryUploadFailed(String error);

  /// No description provided for @gallerySaved.
  ///
  /// In en, this message translates to:
  /// **'Gallery saved'**
  String get gallerySaved;

  /// No description provided for @gallerySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save gallery: {error}'**
  String gallerySaveFailed(String error);

  /// No description provided for @gallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Showcase your best work to attract clients'**
  String get gallerySubtitle;

  /// No description provided for @gallerySaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Gallery'**
  String get gallerySaveButton;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hey, {name} 👋'**
  String supportGreeting(String name);

  /// No description provided for @supportThere.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get supportThere;

  /// No description provided for @supportSearchHint.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get supportSearchHint;

  /// No description provided for @supportPromoTitle.
  ///
  /// In en, this message translates to:
  /// **'Top-Notch support system'**
  String get supportPromoTitle;

  /// No description provided for @supportPromoSub.
  ///
  /// In en, this message translates to:
  /// **'Get quick responses with our online chat'**
  String get supportPromoSub;

  /// No description provided for @supportFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get supportFaqTitle;

  /// No description provided for @supportViewMore.
  ///
  /// In en, this message translates to:
  /// **'View More Questions'**
  String get supportViewMore;

  /// No description provided for @supportChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get supportChat;

  /// No description provided for @supportChatSub.
  ///
  /// In en, this message translates to:
  /// **'Need help? We are here for you'**
  String get supportChatSub;

  /// No description provided for @supportCallSupport.
  ///
  /// In en, this message translates to:
  /// **'Call Support'**
  String get supportCallSupport;

  /// No description provided for @supportCallHours.
  ///
  /// In en, this message translates to:
  /// **'Available Mon - Fri, 9am - 5pm'**
  String get supportCallHours;

  /// No description provided for @supportFaqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a listing?'**
  String get supportFaqQ1;

  /// No description provided for @supportFaqQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I manage bookings?'**
  String get supportFaqQ2;

  /// No description provided for @supportFaqQ3.
  ///
  /// In en, this message translates to:
  /// **'How does escrow payment work?'**
  String get supportFaqQ3;

  /// No description provided for @supportFaqQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I withdraw my earnings?'**
  String get supportFaqQ4;

  /// No description provided for @supportFaqQ5.
  ///
  /// In en, this message translates to:
  /// **'What fees does Planovar charge?'**
  String get supportFaqQ5;

  /// No description provided for @supportFaqQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I verify my account?'**
  String get supportFaqQ6;

  /// No description provided for @supportFaqQ7.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel a booking?'**
  String get supportFaqQ7;

  /// No description provided for @supportFaqQ8.
  ///
  /// In en, this message translates to:
  /// **'How do reviews work?'**
  String get supportFaqQ8;

  /// No description provided for @supportFaqQ9.
  ///
  /// In en, this message translates to:
  /// **'How do I upgrade my subscription?'**
  String get supportFaqQ9;

  /// No description provided for @supportFaqQ10.
  ///
  /// In en, this message translates to:
  /// **'How do I contact a client?'**
  String get supportFaqQ10;

  /// No description provided for @supportQuestionN.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String supportQuestionN(int number);

  /// No description provided for @supportNeedMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'I need more help'**
  String get supportNeedMoreHelp;

  /// No description provided for @supportChatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get supportChatWithUs;

  /// No description provided for @supportCallUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get supportCallUs;

  /// No description provided for @supportCallAvailable.
  ///
  /// In en, this message translates to:
  /// **'We\'re available from Monday- Friday from 9am - 5pm'**
  String get supportCallAvailable;

  /// No description provided for @supportLiveSupport.
  ///
  /// In en, this message translates to:
  /// **'Live Support'**
  String get supportLiveSupport;

  /// No description provided for @supportReplyMinutes.
  ///
  /// In en, this message translates to:
  /// **'We usually reply in a few minutes'**
  String get supportReplyMinutes;

  /// No description provided for @supportChatSetup.
  ///
  /// In en, this message translates to:
  /// **'Live chat is being set up'**
  String get supportChatSetup;

  /// No description provided for @supportChatSetupMsg.
  ///
  /// In en, this message translates to:
  /// **'Our live chat isn\'t connected yet. In the meantime, email us and we\'ll get right back to you.'**
  String get supportChatSetupMsg;

  /// No description provided for @supportEmailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get supportEmailSupport;

  /// No description provided for @supportChatTeam.
  ///
  /// In en, this message translates to:
  /// **'Chat with our team'**
  String get supportChatTeam;

  /// No description provided for @supportChatTeamMsg.
  ///
  /// In en, this message translates to:
  /// **'Open our live chat to talk to a support agent.'**
  String get supportChatTeamMsg;

  /// No description provided for @supportOpenChat.
  ///
  /// In en, this message translates to:
  /// **'Open live chat'**
  String get supportOpenChat;

  /// No description provided for @twofaIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA for additional security'**
  String get twofaIntroTitle;

  /// No description provided for @twofaGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get twofaGetStarted;

  /// No description provided for @twofaSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'2FA Setup'**
  String get twofaSetupTitle;

  /// No description provided for @twofaSetUpUsing.
  ///
  /// In en, this message translates to:
  /// **'Set up using'**
  String get twofaSetUpUsing;

  /// No description provided for @twofaAuthenticatorHint.
  ///
  /// In en, this message translates to:
  /// **'Using the authenticator app such as (Google Authenticator, Authy, 1Password, Last pass etc'**
  String get twofaAuthenticatorHint;

  /// No description provided for @twofaScanMe.
  ///
  /// In en, this message translates to:
  /// **'Scan Me'**
  String get twofaScanMe;

  /// No description provided for @twofaCantScan.
  ///
  /// In en, this message translates to:
  /// **'If you can\'t scan the QR code above, enter this text instead'**
  String get twofaCantScan;

  /// No description provided for @twofaConfirmCode.
  ///
  /// In en, this message translates to:
  /// **'Confirm Code'**
  String get twofaConfirmCode;

  /// No description provided for @twofaEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code provided by the authenticator app'**
  String get twofaEnterCode;

  /// No description provided for @twofaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get twofaConfirm;

  /// No description provided for @twofaAllPrefix.
  ///
  /// In en, this message translates to:
  /// **'All '**
  String get twofaAllPrefix;

  /// No description provided for @twofaDoneWord.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get twofaDoneWord;

  /// No description provided for @twofaSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your 2FA has been successfully enabled'**
  String get twofaSuccessBody;

  /// No description provided for @twofaBackToProfile.
  ///
  /// In en, this message translates to:
  /// **'Back to profile setup'**
  String get twofaBackToProfile;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsActiveListings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get analyticsActiveListings;

  /// No description provided for @analyticsOfTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total} total'**
  String analyticsOfTotal(int total);

  /// No description provided for @analyticsInquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get analyticsInquiries;

  /// No description provided for @analyticsAwaitingReply.
  ///
  /// In en, this message translates to:
  /// **'{count} awaiting reply'**
  String analyticsAwaitingReply(int count);

  /// No description provided for @analyticsRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get analyticsRating;

  /// No description provided for @analyticsReviews.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String analyticsReviews(int count);

  /// No description provided for @analyticsPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get analyticsPlan;

  /// No description provided for @analyticsDetailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed performance analytics'**
  String get analyticsDetailedTitle;

  /// No description provided for @analyticsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Trends, profile views and conversion charts are coming soon.'**
  String get analyticsComingSoon;

  /// No description provided for @payoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payoutsTitle;

  /// No description provided for @payoutsHeadline.
  ///
  /// In en, this message translates to:
  /// **'You keep 100% of what you earn'**
  String get payoutsHeadline;

  /// No description provided for @payoutsBody.
  ///
  /// In en, this message translates to:
  /// **'Planovar runs on a subscription — we don’t hold your money or take a commission. Clients pay you directly, the way you both agree.'**
  String get payoutsBody;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkAllRead;

  /// No description provided for @notifEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notifEmpty;

  /// No description provided for @notifFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifFilterAll;

  /// No description provided for @notifFilterOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get notifFilterOrders;

  /// No description provided for @notifFilterPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get notifFilterPayments;

  /// No description provided for @notifFilterSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifFilterSystem;

  /// No description provided for @notifToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifToday;

  /// No description provided for @notifYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notifYesterday;

  /// No description provided for @notifEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifEarlier;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get statusDeclined;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @statusFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get statusFeatured;

  /// No description provided for @statusPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get statusPremium;

  /// No description provided for @statusBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get statusBasic;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusSuperseded.
  ///
  /// In en, this message translates to:
  /// **'Superseded'**
  String get statusSuperseded;

  /// No description provided for @statusPartiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get statusPartiallyPaid;

  /// No description provided for @ccQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get ccQuote;

  /// No description provided for @ccValidTill.
  ///
  /// In en, this message translates to:
  /// **'Valid till {date}'**
  String ccValidTill(String date);

  /// No description provided for @ccTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ccTotal;

  /// No description provided for @ccInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice · {number}'**
  String ccInvoiceNumber(String number);

  /// No description provided for @ccOrderRequest.
  ///
  /// In en, this message translates to:
  /// **'Order request'**
  String get ccOrderRequest;

  /// No description provided for @ccClientRequesting.
  ///
  /// In en, this message translates to:
  /// **'Client is requesting this — accept to send an invoice'**
  String get ccClientRequesting;

  /// No description provided for @ccDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get ccDecline;

  /// No description provided for @ccAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get ccAccept;

  /// No description provided for @ccDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String ccDue(String date);

  /// No description provided for @ccTaskDone.
  ///
  /// In en, this message translates to:
  /// **'You completed your task'**
  String get ccTaskDone;

  /// No description provided for @ccMarkTaskDone.
  ///
  /// In en, this message translates to:
  /// **'Mark your task done'**
  String get ccMarkTaskDone;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWrong;

  /// No description provided for @errorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get errorTryAgain;

  /// No description provided for @bankAdded.
  ///
  /// In en, this message translates to:
  /// **'Bank account added — you can now receive payments 🎉'**
  String get bankAdded;

  /// No description provided for @bankClientsPayDirect.
  ///
  /// In en, this message translates to:
  /// **'Clients pay you directly to this account.'**
  String get bankClientsPayDirect;

  /// No description provided for @bankLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading banks…'**
  String get bankLoading;

  /// No description provided for @bankSelect.
  ///
  /// In en, this message translates to:
  /// **'Select bank'**
  String get bankSelect;

  /// No description provided for @bankAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit account number'**
  String get bankAccountNumberHint;

  /// No description provided for @bankVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying account…'**
  String get bankVerifying;

  /// No description provided for @bankSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get bankSaving;

  /// No description provided for @bankSaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Save account'**
  String get bankSaveAccount;

  /// No description provided for @bankSearch.
  ///
  /// In en, this message translates to:
  /// **'Search bank'**
  String get bankSearch;

  /// No description provided for @planPopular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get planPopular;

  /// No description provided for @planCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get planCurrentPlan;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// No description provided for @qrcNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get qrcNew;

  /// No description provided for @qrcBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget: {amount}'**
  String qrcBudget(String amount);

  /// No description provided for @qrcBudgetTbd.
  ///
  /// In en, this message translates to:
  /// **'Budget: TBD'**
  String get qrcBudgetTbd;

  /// No description provided for @qrcOpenRespond.
  ///
  /// In en, this message translates to:
  /// **'Open & Respond'**
  String get qrcOpenRespond;

  /// No description provided for @qrcReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get qrcReject;

  /// No description provided for @tagAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add tag...'**
  String get tagAddMore;

  /// No description provided for @tagHelper.
  ///
  /// In en, this message translates to:
  /// **'Press comma or Enter to add a tag  ·  {count}/{max}'**
  String tagHelper(int count, int max);

  /// No description provided for @psCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get psCurrentPassword;

  /// No description provided for @psCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get psCurrentPasswordHint;

  /// No description provided for @psCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get psCurrentPasswordRequired;

  /// No description provided for @psPasswordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be at least 8 characters and include an uppercase letter, a number, and a special character'**
  String get psPasswordTooWeak;

  /// No description provided for @psPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'The new passwords don\'t match'**
  String get psPasswordsDontMatch;

  /// No description provided for @tfaChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get tfaChallengeTitle;

  /// No description provided for @tfaChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app'**
  String get tfaChallengeSubtitle;

  /// No description provided for @tfaVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get tfaVerify;

  /// No description provided for @twofaDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable Two-Factor'**
  String get twofaDisable;

  /// No description provided for @twofaConfirmPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get twofaConfirmPasswordTitle;

  /// No description provided for @twofaContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get twofaContinue;

  /// No description provided for @twofaDisabled.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication disabled'**
  String get twofaDisabled;

  /// No description provided for @twofaSecretCopied.
  ///
  /// In en, this message translates to:
  /// **'Setup key copied'**
  String get twofaSecretCopied;

  /// No description provided for @twofaBackupCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup codes'**
  String get twofaBackupCodesTitle;

  /// No description provided for @twofaBackupCodesHint.
  ///
  /// In en, this message translates to:
  /// **'Save these somewhere safe — each can be used once if you lose your authenticator.'**
  String get twofaBackupCodesHint;

  /// No description provided for @cqAfterEvent.
  ///
  /// In en, this message translates to:
  /// **'After the event'**
  String get cqAfterEvent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
