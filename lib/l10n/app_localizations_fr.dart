// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Langue';

  @override
  String get languageIntro =>
      'Choisissez votre langue préférée. L\'anglais est disponible maintenant — d\'autres arrivent bientôt.';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get retry => 'Réessayer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get search => 'Rechercher';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navEvents => 'Événements';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profil';

  @override
  String get navListings => 'Annonces';

  @override
  String get navOrders => 'Commandes';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue =>
      'Connectez-vous pour continuer votre parcours sur Planovar';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailHint => 'Saisissez votre adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Saisissez le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get orLabel => 'ou';

  @override
  String get noAccountQuestion => 'Vous n\'avez pas de compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get onboardingTitle1 =>
      'Accédez à des milliers de clients événementiels';

  @override
  String get onboardingSubtitle1 =>
      'Connectez-vous avec des couples, des entreprises et des organisateurs d\'événements de votre région, tous à la recherche active de prestataires comme vous';

  @override
  String get onboardingTitle2 => 'Gérez tout depuis un seul tableau de bord';

  @override
  String get onboardingSubtitle2 =>
      'Suivez vos demandes, réservations et conversations depuis un espace de travail unique';

  @override
  String get onboardingTitle3 =>
      'Présentez votre travail, faites-vous découvrir';

  @override
  String get onboardingSubtitle3 =>
      'Répertoriez vos produits, services et locations, puis abonnez-vous pour grimper dans les classements de recherche et atteindre les organisateurs d\'événements en premier.';

  @override
  String get onboardingListBusiness => 'Répertorier mon entreprise';

  @override
  String get onboardingHaveAccount => 'J\'ai déjà un compte';

  @override
  String get loginSubtitle => 'Connectez-vous à votre compte prestataire';

  @override
  String get emailPlaceholder => 'votrenom@entreprise.com';

  @override
  String get loginPasswordHint => 'Saisissez votre mot de passe';

  @override
  String get registerTitle => 'Créez votre compte prestataire';

  @override
  String get registerSubtitle =>
      'Commencez à répertorier votre entreprise sur Planovar';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameHint => 'p. ex. Ada';

  @override
  String get lastName => 'Nom';

  @override
  String get lastNameHint => 'p. ex. Obi';

  @override
  String get businessName => 'Nom de l\'entreprise';

  @override
  String get businessNameHint => 'p. ex. Sugared Dreams Cakery';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get dobPlaceholder => 'JJ / MM / AAAA';

  @override
  String get selectDob => 'Sélectionnez votre date de naissance';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumberHint => '8012345678';

  @override
  String get createPassword => 'Créer un mot de passe';

  @override
  String get createPasswordHint => 'Min. 8 caractères';

  @override
  String get registerAgreePrefix => 'En cochant la case, vous acceptez nos ';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get registerAgreeAnd => ' et notre ';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get signInAction => 'Se connecter';

  @override
  String get forgotResetTitle => 'Réinitialisez votre mot de passe';

  @override
  String get forgotResetIntro =>
      'Saisissez votre adresse e-mail et nous vous enverrons un code à 6 chiffres pour réinitialiser votre mot de passe.';

  @override
  String forgotResetSentTo(String email) {
    return 'Un code de réinitialisation a été envoyé à $email. Vérifiez votre boîte de réception.';
  }

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get sendResetCode => 'Envoyer le code de réinitialisation';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSuccess =>
      'Mot de passe réinitialisé avec succès. Veuillez vous connecter.';

  @override
  String get resetCreateNewPassword => 'Créez un nouveau mot de passe';

  @override
  String get resetCodeSentTo => 'Saisissez le code à 6 chiffres envoyé à ';

  @override
  String get resetChoosePassword => ' et choisissez un nouveau mot de passe.';

  @override
  String get verificationCode => 'Code de vérification';

  @override
  String get sixDigitCode => 'Code à 6 chiffres';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get atLeast8Chars => 'Au moins 8 caractères';

  @override
  String get mustBeAtLeast8Chars => 'Doit contenir au moins 8 caractères';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordHint => 'Ressaisissez votre nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get verifyEmailTitle => 'Vérifiez votre e-mail';

  @override
  String get verifyEmailIntro =>
      'Nous avons envoyé un code OTP à 6 chiffres à votre adresse e-mail';

  @override
  String get verifyNewCodeSent => 'Un nouveau code a été envoyé';

  @override
  String verifyCouldNotResend(String error) {
    return 'Impossible de renvoyer le code : $error';
  }

  @override
  String get proceed => 'Continuer';

  @override
  String verifyResendIn(int seconds) {
    return 'Renvoyer le code dans $seconds s';
  }

  @override
  String get resendCodeAction => 'Renvoyer le code';

  @override
  String get setupBusinessSetup => 'Configuration de l\'entreprise';

  @override
  String get setupBusinessProfileTitle => 'Profil de l\'entreprise';

  @override
  String get setupBusinessProfileSubtitle => 'Dites aux clients qui vous êtes';

  @override
  String get setupLicensedBusiness => 'Entreprise agréée';

  @override
  String get setupLicensedBusinessDesc =>
      'Société, agence ou studio enregistré';

  @override
  String get setupFreelancer => 'Indépendant';

  @override
  String get setupFreelancerDesc =>
      'Particulier proposant des services professionnels';

  @override
  String get setupCouldNotLoadCategories =>
      'Impossible de charger les catégories';

  @override
  String get setupCouldNotReadFile =>
      'Impossible de lire le fichier sélectionné';

  @override
  String get setupFileTooLarge => 'Le fichier dépasse 5 Mo';

  @override
  String get setupBusinessLogoOptional => 'Logo de l\'entreprise (facultatif)';

  @override
  String get setupBusinessDescription => 'Description de l\'entreprise';

  @override
  String get setupBusinessDescriptionHint =>
      'Dites aux clients ce qui rend votre entreprise spéciale, votre expérience et ce que vous proposez...';

  @override
  String get setupProofOfOwnership => 'Preuve de propriété';

  @override
  String get setupProofOptionalFreelancers =>
      '(facultatif pour les indépendants)';

  @override
  String get setupDocumentUploaded => 'Document téléchargé';

  @override
  String get setupTapToReplace => 'Appuyez pour remplacer';

  @override
  String get setupTapToUpload => 'Appuyez pour télécharger';

  @override
  String get setupUploadFileTypes => 'JPG, PNG ou PDF jusqu\'à 5 Mo';

  @override
  String get setupCategoryTags => 'Étiquettes de catégorie';

  @override
  String get setupNoCategories => 'Aucune catégorie disponible pour le moment';

  @override
  String get setupLocationTitle => 'Localisation et portée';

  @override
  String get setupLocationSubtitle => 'Où opérez-vous ?';

  @override
  String get setupTurnOnLocation =>
      'Activez les services de localisation pour utiliser ceci.';

  @override
  String get setupLocationDenied =>
      'Autorisation de localisation refusée — choisissez votre ville manuellement.';

  @override
  String get setupCouldNotDetermineCity =>
      'Impossible de déterminer votre ville — veuillez la choisir manuellement.';

  @override
  String get setupCouldNotGetLocation =>
      'Impossible d\'obtenir votre position. Veuillez choisir votre ville manuellement.';

  @override
  String get selectCountry => 'Sélectionner le pays';

  @override
  String get selectCity => 'Sélectionner la ville';

  @override
  String get selectYourCity => 'Sélectionnez votre ville';

  @override
  String get country => 'Pays';

  @override
  String get city => 'Ville';

  @override
  String get setupLocating => 'Localisation…';

  @override
  String get setupUseCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get setupVendorType => 'Type de prestataire';

  @override
  String get setupProductsOnly => 'Produits uniquement';

  @override
  String get setupServicesOnly => 'Services uniquement';

  @override
  String get setupBothProductsServices => 'Produits et services';

  @override
  String get setupChoosePlanTitle => 'Choisissez votre forfait';

  @override
  String get setupChoosePlanSubtitle =>
      'Améliorez à tout moment. Annulez à tout moment.';

  @override
  String get setupCouldNotLoadPlans =>
      'Impossible de charger les forfaits. Vérifiez votre connexion et réessayez.';

  @override
  String setupSelectPlan(String plan) {
    return 'Choisir $plan';
  }

  @override
  String get setupSkipForNow => 'Ignorer pour l\'instant';

  @override
  String get setupVerifyIdentityTitle => 'Vérifiez votre identité';

  @override
  String get setupVerifyIdentitySubtitle =>
      'Téléchargez votre NIN, et votre CAC si vous dirigez une entreprise agréée. Stocké en toute sécurité.';

  @override
  String get setupUploaded => 'Téléchargé';

  @override
  String get setupUploadNin => 'Téléchargez votre attestation NIN';

  @override
  String get setupUploadCac => 'Téléchargez votre document CAC';

  @override
  String get setupPaymentNotCompleted =>
      'Paiement non finalisé — vous pouvez souscrire à un forfait payant à tout moment depuis votre profil.';

  @override
  String get setupSomethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get setupSettingUp => 'Configuration…';

  @override
  String get setupFinishSetup => 'Terminer la configuration';

  @override
  String get setupCompleteVerificationLater =>
      'Vous pouvez compléter la vérification plus tard depuis votre profil.';

  @override
  String get selectBank => 'Sélectionner la banque';

  @override
  String get setupPayoutTitle => 'Détails de versement';

  @override
  String get setupPayoutSubtitle => 'Où devons-nous envoyer vos gains ?';

  @override
  String get setupBankName => 'Nom de la banque';

  @override
  String get setupSelectYourBank => 'Sélectionnez votre banque';

  @override
  String get setupAccountNumber => 'Numéro de compte';

  @override
  String get setupAccountNumberHint => '0123456789';

  @override
  String get setupAccountName => 'Nom du compte';

  @override
  String get setupAutoVerified => 'Vérifié automatiquement';

  @override
  String get setupPayoutSchedule => 'Calendrier des versements';

  @override
  String get setupPayoutRolling => 'En continu · 24–48 h après réalisation';

  @override
  String get setupPayoutCommission =>
      'Commission de la plateforme · Déduite avant le versement';

  @override
  String get setupMinimumPayout => 'Versement minimum · ₦1 000';

  @override
  String get setupSecuredByPaystack => 'Sécurisé par Paystack';

  @override
  String get setupSavePayoutDetails => 'Enregistrer les détails de versement';

  @override
  String get setupAllSet => 'Tout est prêt !';

  @override
  String get setupProfileLive =>
      'Votre profil prestataire est en ligne sur Planovar. Commencez à ajouter vos produits et services pour atteindre des milliers d\'organisateurs d\'événements à Lagos.';

  @override
  String get setupAddFirstListing => 'Ajoutez votre première annonce';

  @override
  String get setupAddFirstListingSub => 'Produits, services ou locations';

  @override
  String get setupUpgradePlan => 'Améliorez votre forfait';

  @override
  String get setupUpgradePlanSub => 'Obtenez plus de visibilité et d\'analyses';

  @override
  String get setupGoToDashboard => 'Aller au tableau de bord';

  @override
  String get payCompletePayment => 'Finaliser le paiement';

  @override
  String get paySecurePayment => 'Paiement sécurisé';

  @override
  String get payBrowserFailed =>
      'Nous n\'avons pas pu ouvrir votre navigateur. Appuyez ci-dessous pour ouvrir le paiement sécurisé Paystack.';

  @override
  String get payBrowserOpened =>
      'Nous avons ouvert le paiement sécurisé Paystack dans votre navigateur. Finalisez votre paiement là-bas, puis revenez et appuyez sur le bouton ci-dessous.';

  @override
  String get payOpenPaymentPage => 'Ouvrir la page de paiement';

  @override
  String get payReopenPaymentPage => 'Rouvrir la page de paiement';

  @override
  String get payCompletedPayment => 'J\'ai finalisé le paiement';

  @override
  String get homeTodaysSchedule => 'Programme du jour';

  @override
  String get homeQuickAction => 'Action rapide';

  @override
  String get viewAll => 'Voir tout';

  @override
  String homeNewRequestsAttention(int count) {
    return '$count nouvelles demandes requièrent votre attention';
  }

  @override
  String homeNewRequestsSubtitle(int count) {
    return 'Vous avez $count nouvelles demandes pour vos annonces';
  }

  @override
  String get homeConfirmedBookings => 'Réservations confirmées';

  @override
  String get homePendingRequests => 'Demandes en attente';

  @override
  String get homeThisMonth => 'Ce mois-ci';

  @override
  String homeBookingsCount(int count) {
    return '$count réservations';
  }

  @override
  String get homeAvgRating => 'Note moyenne';

  @override
  String homeFromReviews(int count) {
    return 'sur $count avis';
  }

  @override
  String get homeNoSchedule => 'Aucun programme pour aujourd\'hui';

  @override
  String get homeAddListing => 'Ajouter une annonce';

  @override
  String get homeAnalytics => 'Analyses';

  @override
  String get homeUpgradePlanShort => 'Améliorer le forfait';

  @override
  String get homePayouts => 'Versements';

  @override
  String get homeGoodMorning => 'Bonjour,';

  @override
  String get homeGoodAfternoon => 'Bon après-midi,';

  @override
  String get homeGoodEvening => 'Bonsoir,';

  @override
  String get listingTypeTitle => 'Type d\'annonce';

  @override
  String get listingTypeSubtitle =>
      'Sélectionnez le type d\'annonce que vous souhaitez créer';

  @override
  String get listingTypeService => 'Service';

  @override
  String get listingTypeServiceDesc => 'rendez-vous réservable';

  @override
  String get listingTypeProduct => 'Produit';

  @override
  String get listingTypeProductDesc => 'Article physique à louer ou à vendre';

  @override
  String get homeActionNeeded => 'Action requise';

  @override
  String get homeAllCaughtUp => 'Vous êtes à jour';

  @override
  String get homeNoInquiriesWaiting =>
      'Aucune demande n\'attend votre réponse.';

  @override
  String get homeNewInquiry => 'Nouvelle demande';

  @override
  String get homeNewBadge => 'Nouveau';

  @override
  String get homeOpenRespond => 'Ouvrir et répondre';

  @override
  String get addListingNewListing => 'Nouvelle annonce';

  @override
  String get addListingServiceDesc => 'Rendez-vous réservable';

  @override
  String get addSuccessSuccessfully => 'avec succès';

  @override
  String addSuccessAddedTitle(String label) {
    return '$label ajouté ';
  }

  @override
  String addSuccessPendingSubtitle(String label) {
    return 'Votre $label a été enregistré. Il deviendra visible pour les clients une fois votre compte vérifié.';
  }

  @override
  String get addSuccessLiveService =>
      'Votre service a été ajouté avec succès et est actuellement en ligne';

  @override
  String get addSuccessLiveProduct =>
      'Votre produit a été ajouté avec succès et est actuellement en ligne';

  @override
  String get addSuccessPendingWarning =>
      'Vérification en attente — les clients ne peuvent pas voir vos annonces tant qu\'un administrateur n\'a pas vérifié votre compte. Nous vous préviendrons une fois approuvé.';

  @override
  String addSuccessIdLabel(String label) {
    return 'ID $label';
  }

  @override
  String get addSuccessSku => 'SKU';

  @override
  String get addSuccessDateCreated => 'Date de création';

  @override
  String addSuccessViewLabel(String label) {
    return 'Voir $label';
  }

  @override
  String get listingBadgeProductRental => 'Produit (Location)';

  @override
  String listingPerDay(String price) {
    return '$price / jour';
  }

  @override
  String get listingQuoteBased => 'Sur devis';

  @override
  String get listingsMyListings => 'Mes annonces';

  @override
  String listingsTabAll(int count) {
    return 'Toutes ($count)';
  }

  @override
  String listingsTabServices(int count) {
    return 'Services ($count)';
  }

  @override
  String listingsTabProducts(int count) {
    return 'Produits ($count)';
  }

  @override
  String listingsTabRentals(int count) {
    return 'Locations ($count)';
  }

  @override
  String listingsOutOfStockCount(int count) {
    return '$count articles en rupture de stock, ';
  }

  @override
  String get listingsClickToUpdate => 'Cliquez pour mettre à jour';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusInactive => 'Inactif';

  @override
  String get listingsPendingReview => 'En attente d\'examen';

  @override
  String get listingsEmptyTitle => 'Aucune annonce pour le moment';

  @override
  String get listingsEmptySubtitle =>
      'Appuyez sur + pour ajouter votre première annonce';

  @override
  String get listingsAddListing => 'Ajouter une annonce';

  @override
  String get listingsCouldNotLoad => 'Impossible de charger vos annonces';

  @override
  String get oosTitle => 'Annonces en rupture de stock';

  @override
  String get oosRental => 'Location';

  @override
  String oosReactivated(String noun) {
    return '$noun réactivé';
  }

  @override
  String get oosBadge => 'Rupture de stock';

  @override
  String get oosRestock => 'Réapprovisionner';

  @override
  String get oosEmptyTitle => 'Toutes les annonces sont en stock !';

  @override
  String get oosEmptySubtitle =>
      'Aucun article en rupture de stock dans cette catégorie';

  @override
  String get category => 'Catégorie';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get apGenerateSkuHint =>
      'Saisissez d\'abord le nom du produit, puis générez un SKU.';

  @override
  String get apNameDescRequired =>
      'Le nom et la description du produit sont requis';

  @override
  String get apSelectCategory => 'Veuillez sélectionner une catégorie';

  @override
  String get apSelectACategory => 'Sélectionnez une catégorie';

  @override
  String get apNoCategoriesProfile =>
      'Vous n\'avez pas encore ajouté de catégories à votre profil. Ajoutez-les dans Profil → Détails de l\'entreprise pour répertorier des produits ici.';

  @override
  String get apOnlyRegisteredCategories =>
      'Seules vos catégories enregistrées sont affichées. Ajoutez-en plus dans Profil → Détails de l\'entreprise.';

  @override
  String get apForSale => 'À vendre';

  @override
  String get apForRent => 'À louer';

  @override
  String get apTitle => 'Ajouter un produit';

  @override
  String get apSubtitle => 'Ajoutez un produit à votre catalogue';

  @override
  String get apProductName => 'Nom du produit';

  @override
  String get apProductNameHint => 'Saisissez le nom du produit...';

  @override
  String get apProductDescription => 'Description du produit';

  @override
  String get apProductDescriptionHint => 'Décrivez votre produit...';

  @override
  String get apProductPrice => 'Prix du produit';

  @override
  String get apPricePerDay => 'Prix par jour';

  @override
  String get apRefundableDeposit => 'Caution remboursable';

  @override
  String get apRentalDuration => 'Durée de location (jours)';

  @override
  String get apRentalDurationHint => 'p. ex. 3';

  @override
  String get apSkuHint => 'Saisissez le SKU du produit...';

  @override
  String get apGenerateForMe => 'Générer pour moi';

  @override
  String get apQuantityInStock => 'Quantité en stock';

  @override
  String get apQuantityHint => 'Combien en avez-vous en stock';

  @override
  String get apAvailableSizes => 'Tailles disponibles (facultatif)';

  @override
  String get apTags => 'Étiquettes';

  @override
  String get apTagsHint => 'p. ex. Mariage, Gâteau, Luxe';

  @override
  String get apProductPhotos => 'Photos du produit';

  @override
  String get apFrontPhoto => 'Photo de face';

  @override
  String get apBackPhoto => 'Photo de dos';

  @override
  String get apSidePhoto => 'Photo de côté';

  @override
  String get apDetailPhoto => 'Photo de détail';

  @override
  String get apPublishing => 'Publication…';

  @override
  String get apPublishProduct => 'Publier le produit';

  @override
  String get gotIt => 'Compris';

  @override
  String get asNameDescRequired =>
      'Le nom et la description du service sont requis';

  @override
  String get asNoCategoriesProfile =>
      'Vous n\'avez pas encore ajouté de catégories à votre profil. Ajoutez-les dans Profil → Détails de l\'entreprise pour répertorier des services ici.';

  @override
  String get asCancellationPolicy => 'Politique d\'annulation';

  @override
  String get policyFlexible => 'Flexible';

  @override
  String get policyModerate => 'Modérée';

  @override
  String get policyStrict => 'Stricte';

  @override
  String get policyFlexibleDesc =>
      'Remboursement intégral si le client annule jusqu\'à 24 heures avant l\'événement.';

  @override
  String get policyModerateDesc =>
      'Remboursement de 50 % si annulé au moins 7 jours avant l\'événement ; aucun après.';

  @override
  String get policyStrictDesc =>
      'Aucun remboursement une fois la réservation confirmée.';

  @override
  String get asCategoryInfo =>
      'La catégorie de service que les clients parcourent. Seules les catégories enregistrées sur votre profil apparaissent ici.';

  @override
  String get asPriceRange => 'Fourchette de prix';

  @override
  String get asPriceRangeInfo =>
      'La fourchette de prix habituelle pour ce service. Les clients la voient comme un guide ; le montant final est convenu dans votre devis.';

  @override
  String get asMin => 'Min';

  @override
  String get asMax => 'Max';

  @override
  String get asServiceDuration => 'Durée du service';

  @override
  String get durationDays => 'Jours';

  @override
  String get durationHours => 'Heures';

  @override
  String get durationMins => 'Min';

  @override
  String get asDurationHint => 'Saisissez la valeur de durée...';

  @override
  String get asSelectPolicy => 'Sélectionnez une politique';

  @override
  String get asCancellationPolicyInfo =>
      'Comment fonctionnent les remboursements si un client annule. Choisissez le niveau qui convient le mieux à votre entreprise.';

  @override
  String get asTitle => 'Ajouter un service';

  @override
  String get asSubtitle => 'Ajoutez un service pour votre entreprise';

  @override
  String get asServiceName => 'Nom du service';

  @override
  String get asServiceNameHint => 'Saisissez le nom du service...';

  @override
  String get asServiceNameInfo =>
      'Un nom court et clair que les clients verront, p. ex. « Photographie de mariage — Journée complète ».';

  @override
  String get asServiceDescription => 'Description du service';

  @override
  String get asServiceDescriptionHint => 'Décrivez votre service...';

  @override
  String get asServiceDescriptionInfo =>
      'Ce qui est inclus, votre expérience et ce à quoi les clients peuvent s\'attendre. Plus il y a de détails, plus il y a de confiance.';

  @override
  String get asTagsHint => 'p. ex. Mariage, Photographie, Extérieur';

  @override
  String get asServicePhotos => 'Photos du service';

  @override
  String asPhotoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get asPublishService => 'Publier le service';

  @override
  String get loading => 'Chargement…';

  @override
  String get ldNotFound => 'Annonce introuvable';

  @override
  String get ldServiceLower => 'service';

  @override
  String get ldProductLower => 'produit';

  @override
  String ldDeleted(String noun) {
    return '$noun supprimé';
  }

  @override
  String ldDeactivated(String noun) {
    return '$noun désactivé';
  }

  @override
  String get ldEditService => 'Modifier le service';

  @override
  String get ldEditProduct => 'Modifier le produit';

  @override
  String get ldDeleteService => 'Supprimer le service';

  @override
  String get ldDeleteProduct => 'Supprimer le produit';

  @override
  String get ldDeactivateService => 'Désactiver le service';

  @override
  String get ldDeactivateProduct => 'Désactiver le produit';

  @override
  String get ldViews30d => 'Vues (30 j)';

  @override
  String get ldRating => 'Note';

  @override
  String get ldNoReviews => 'Aucun avis pour le moment';

  @override
  String get ldFixedPrice => 'Prix fixe';

  @override
  String get ldStartingFrom => 'À partir de';

  @override
  String get ldQuoteOnRequest => 'Devis sur demande';

  @override
  String get ldType => 'Type';

  @override
  String get ldPricePerDay => 'Prix par jour';

  @override
  String get ldStock => 'Stock';

  @override
  String get ldCancellationPolicy => 'Politique d\'annulation';

  @override
  String get ldPrice => 'Prix';

  @override
  String ldFrom(String price) {
    return 'À partir de $price';
  }

  @override
  String get ldPricing => 'Tarification';

  @override
  String get ldDuration => 'Durée';

  @override
  String ldInStock(int count) {
    return '$count en stock';
  }

  @override
  String get ldStatus => 'Statut';

  @override
  String get ldListed => 'Publié';

  @override
  String ldDeleteTitle(String noun) {
    return 'Supprimer $noun';
  }

  @override
  String ldDeleteBody(String noun) {
    return 'Êtes-vous sûr de vouloir supprimer définitivement ce $noun';
  }

  @override
  String get ldNevermind => 'Annuler';

  @override
  String get ldYesDelete => 'Oui, supprimer';

  @override
  String ldDeactivateTitle(String noun) {
    return 'Désactiver $noun';
  }

  @override
  String ldDeactivateBody(String noun) {
    return 'Êtes-vous sûr de vouloir désactiver temporairement ce $noun';
  }

  @override
  String get ldDeactivationPeriod => 'Période de désactivation';

  @override
  String get ldSelectDuration => 'Sélectionner une durée';

  @override
  String get ldSelectDurationTitle => 'Sélectionner une durée';

  @override
  String get ld1Week => '1 semaine';

  @override
  String get ld2Weeks => '2 semaines';

  @override
  String get ld1Month => '1 mois';

  @override
  String get ld3Months => '3 mois';

  @override
  String get ldYesDeactivate => 'Oui, désactiver';

  @override
  String get done => 'Terminé';

  @override
  String elUpdateTitle(String label) {
    return 'Modifier $label';
  }

  @override
  String get elServiceSubtitle =>
      'Mettez à jour ce service pour votre entreprise';

  @override
  String get elProductSubtitle =>
      'Mettez à jour votre produit et augmentez votre stock';

  @override
  String get elPhotoComingSoon => 'Téléchargement de photo bientôt disponible';

  @override
  String get elSelectSizes => 'Sélectionner les tailles';

  @override
  String get elForSale => 'À vendre';

  @override
  String get elForRent => 'À louer';

  @override
  String get elProductType => 'Type de produit 📦';

  @override
  String get elSelectType => 'Sélectionner le type';

  @override
  String get elProductTypeSheet => 'Type de produit';

  @override
  String get elSizes => 'Tailles ';

  @override
  String get elOptional => '(facultatif)';

  @override
  String get elSelectSizesPlaceholder => 'Sélectionnez les tailles';

  @override
  String get elRentalDuration => 'Durée de location';

  @override
  String get elSkuHint => 'Saisissez le SKU...';

  @override
  String get elMainPhoto => 'Photo principale';

  @override
  String get elSecondPhoto => 'Deuxième photo';

  @override
  String get elThirdPhoto => 'Troisième photo';

  @override
  String get elFourthPhoto => 'Quatrième photo';

  @override
  String get elUpdatedSuccess => 'Annonce mise à jour avec succès';

  @override
  String get trackingTitle => 'Suivi de commande';

  @override
  String get trackingComingSoon => 'Le suivi de commande arrive bientôt';

  @override
  String get trackingComingSoonBody =>
      'Le suivi de livraison et de location apparaîtra ici une fois disponible.';

  @override
  String get reviewClientFallback => 'Client';

  @override
  String get reviewTitle => 'Avis';

  @override
  String reviewSubtitle(String name) {
    return 'Dites-nous comment s\'est passée votre expérience avec $name';
  }

  @override
  String get reviewFeedbackLabel => 'Laissez un avis détaillé';

  @override
  String get reviewFeedbackHint =>
      'Dites-nous comment s\'est passée votre expérience';

  @override
  String get reviewSubmitted => 'Avis envoyé !';

  @override
  String get reviewSendReview => 'Envoyer l\'avis';

  @override
  String get cancelBookingTitle => 'Annuler la réservation';

  @override
  String get coReason1 => 'Le client était impoli';

  @override
  String get coReason2 => 'L\'événement dépassait ce qui était décrit';

  @override
  String get coReason3 => 'Le client était en retard à l\'événement';

  @override
  String get coReason4 => 'Le client a refusé de payer le deuxième acompte';

  @override
  String get coReason5 => 'Autre problème';

  @override
  String get coNotice =>
      'Notre équipe assure la médiation de tous les litiges. Nous visons une résolution sous 48 heures. Essayez d\'abord de contacter le client — la plupart des problèmes se résolvent rapidement.';

  @override
  String get coReasonTitle => 'Raison de l\'annulation de la réservation';

  @override
  String get coDescribeIssue => 'Décrivez le problème';

  @override
  String get coDescribeHint =>
      'Décrivez en détail ce qui s\'est passé, en incluant les dates, les montants et tout contexte pertinent';

  @override
  String get coAttachEvidence => 'Joindre des preuves (facultatif)';

  @override
  String get coUploadImage => 'Téléverser une image';

  @override
  String get coBookingCancelled => 'Réservation annulée';

  @override
  String get coCancelOrder => 'Annuler la commande';

  @override
  String get coMessageClient => 'Contacter le client à la place';

  @override
  String get msgTitle => 'Messages';

  @override
  String get msgSubtitle => 'Restez en contact avec vos clients';

  @override
  String get msgSearchHint => 'Rechercher des conversations';

  @override
  String get msgNoConversations => 'Aucune conversation trouvée';

  @override
  String msgParticipants(int count) {
    return '$count participants';
  }

  @override
  String get convConfirmed => 'Confirmé';

  @override
  String get convDeclined => 'Refusé';

  @override
  String get convQuoteExpired => 'Devis expiré';

  @override
  String convDepositRefundedAmt(String amount) {
    return 'Caution remboursée · ₦$amount';
  }

  @override
  String get convDepositRefunded => 'Caution remboursée';

  @override
  String convPaymentReceivedAmt(String amount) {
    return 'Paiement reçu · ₦$amount';
  }

  @override
  String get convPaymentReceived => 'Paiement reçu';

  @override
  String get convOrderUpdate => 'Mise à jour de la commande';

  @override
  String get convReviewRequested => 'Avis demandé';

  @override
  String convReviewLeftRating(String rating) {
    return 'Le client a laissé un avis · $rating★';
  }

  @override
  String get convReviewLeft => 'Le client a laissé un avis';

  @override
  String get convBankBanner =>
      'Devis accepté — ajoutez votre compte bancaire pour être payé.';

  @override
  String get convAdd => 'Ajouter';

  @override
  String get convConfirmReturn => 'Confirmer le retour';

  @override
  String get convMarkDelivered => 'Marquer comme livré';

  @override
  String get convPostUpdate => 'Publier une mise à jour';

  @override
  String get convConfirmReturnTitle => 'Confirmer le retour de la location ?';

  @override
  String get convConfirmReturnBody =>
      'Ceci finalise la location et rembourse la caution du client. Renvoyez la caution au client depuis votre banque.';

  @override
  String get convRentalCompleted => 'Location terminée — caution remboursée 🎉';

  @override
  String get convPostUpdateTitle => 'Publier une mise à jour';

  @override
  String get convPostUpdateHint =>
      'ex. En cours de livraison — arrivée avant 16h';

  @override
  String get convPost => 'Publier';

  @override
  String get convUpdatePosted => 'Mise à jour publiée';

  @override
  String get convMarkDeliveredTitle => 'Marquer comme livré ?';

  @override
  String get convMarkDeliveredBody =>
      'Ceci finalise la réservation et invite le client à laisser un avis.';

  @override
  String get convMarkedDelivered => 'Marqué comme livré 🎉';

  @override
  String get convReviseQuote => 'Réviser le devis';

  @override
  String get convCreateSendQuote => 'Créer et envoyer un devis';

  @override
  String get convOrderAccepted => 'Commande acceptée — facture envoyée 🎉';

  @override
  String get convOrderDeclined => 'Commande refusée';

  @override
  String get convCouldNotIdentifyClient => 'Impossible d\'identifier le client';

  @override
  String get convCouldNotUpdateTask => 'Impossible de mettre à jour la tâche';

  @override
  String get convCouldNotLoadListings => 'Impossible de charger vos annonces';

  @override
  String get convAddListingFirst =>
      'Ajoutez d\'abord une annonce pour envoyer un devis';

  @override
  String get convQuoteForListing => 'Devis pour quelle annonce ?';

  @override
  String get convTypeMessage => 'Écrivez un message';

  @override
  String get cqAddLineItem => 'Ajoutez au moins une ligne avec un montant';

  @override
  String get cqRevisedSent => 'Devis révisé envoyé 🎉';

  @override
  String get cqQuoteSent => 'Devis envoyé au client 🎉';

  @override
  String get cqOpenFromChat =>
      'Ouvrez ceci depuis une discussion ou une demande client pour envoyer un devis';

  @override
  String get cqValidForTitle => 'Devis valable';

  @override
  String get cqTitleCreate => 'Créer un devis';

  @override
  String get cqEvent => 'Événement';

  @override
  String get cqDescription => 'Description';

  @override
  String get cqAmount => 'Montant';

  @override
  String get cqAddItem => '+ Ajouter un article';

  @override
  String cqSubtotal(String amount) {
    return 'Sous-total $amount';
  }

  @override
  String cqMilestone(int number) {
    return 'Étape $number';
  }

  @override
  String get cqLineItems => 'Articles';

  @override
  String get cqSetPaymentTerms => 'Conditions de paiement (facultatif)';

  @override
  String get cqPaymentTermsHint =>
      'ex. 50 % d\'acompte, solde à la livraison — payé directement';

  @override
  String get cqNoteToClient => 'Note au client';

  @override
  String get cqNoteHint => 'Brève description du produit';

  @override
  String get cqSending => 'Envoi…';

  @override
  String get cqSendRevised => 'Envoyer le devis révisé';

  @override
  String get cqCreateQuote => 'Créer un devis';

  @override
  String get cqDueOnConfirmation =>
      'À régler à la confirmation de la réservation (immédiatement)';

  @override
  String get cqTermPayAtOnce => 'Payer en une fois';

  @override
  String get cqTermCustom => 'Personnalisé';

  @override
  String get cqValid1Day => '1 jour';

  @override
  String get cqValid3Days => '3 jours';

  @override
  String get cqValid7Days => '7 jours';

  @override
  String get cqValid14Days => '14 jours';

  @override
  String get cqValid30Days => '30 jours';

  @override
  String get ciTitle => 'Créer une facture';

  @override
  String get ciInvoiceItems => 'Articles de la facture';

  @override
  String get ciPaymentMilestones => 'Échéances de paiement';

  @override
  String get ciFromQuote => 'Du devis';

  @override
  String get ciBanner =>
      'Pré-rempli à partir du devis accepté QT-2026-047. Vérifiez les articles et les échéances de paiement, puis envoyez pour confirmer la réservation.';

  @override
  String get ciPayoutToAccount => 'Versement sur votre compte';

  @override
  String get ciAccount => 'Compte';

  @override
  String get ciYourPayout => 'Votre versement';

  @override
  String ciSendInvoiceTo(String name) {
    return 'Envoyer la facture à $name';
  }

  @override
  String get ciInvoiceSent => 'Facture envoyée avec succès !';

  @override
  String get ciPreview => 'Aperçu';

  @override
  String get profileYourBusiness => 'Votre entreprise';

  @override
  String profilePlanLabel(String tier) {
    return 'Forfait $tier';
  }

  @override
  String get profileVerified => 'Vérifié';

  @override
  String get profileUnverified => 'Non vérifié';

  @override
  String get profileGeneral => 'Général';

  @override
  String get profilePreferences => 'Préférences';

  @override
  String get profileUpdateProfile => 'Mettre à jour votre profil';

  @override
  String get profileSecurity => 'Sécurité';

  @override
  String get profileReviews => 'Avis';

  @override
  String get profileLinkedBanks => 'Comptes bancaires liés';

  @override
  String get profileGallery => 'Galerie';

  @override
  String get profileSubscriptionPlans => 'Forfaits d\'abonnement';

  @override
  String get profileLanguagePref => 'Préférence de langue';

  @override
  String get profileTheme => 'Thème';

  @override
  String get profileCustomizeStorefront => 'Personnaliser votre vitrine';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileHelpSupport => 'Aide et assistance';

  @override
  String get profileTerms => 'Conditions générales';

  @override
  String get profileLeavePlanovar => 'Quitter Planovar';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String psUploadLogoFailed(String error) {
    return 'Impossible de téléverser le logo : $error';
  }

  @override
  String psUploadCoverFailed(String error) {
    return 'Impossible de téléverser la couverture : $error';
  }

  @override
  String get psProfileUpdated => 'Profil mis à jour';

  @override
  String get psEmailAddress => 'Adresse e-mail';

  @override
  String get psEmailHint => 'Adresse e-mail';

  @override
  String get psPhoneNumber => 'Numéro de téléphone';

  @override
  String get psPhoneHint => 'Numéro de téléphone';

  @override
  String get psDateOfBirth => 'Date de naissance';

  @override
  String get psUpdateDetails => 'Mettre à jour';

  @override
  String get psAddCoverPhoto => 'Ajouter une photo de couverture';

  @override
  String get psStorefrontHint =>
      'Votre logo et votre couverture sont ce que les clients voient sur votre vitrine.';

  @override
  String get psStorefrontImages => 'Images de la vitrine';

  @override
  String get psBusinessName => 'Nom de l\'entreprise';

  @override
  String get psBusinessNameHint => 'Nom de l\'entreprise';

  @override
  String get psBusinessType => 'Type d\'entreprise';

  @override
  String get psBizLicensed => 'Entreprise agréée';

  @override
  String get psBizFreelancer => 'Indépendant';

  @override
  String get psBusinessDescription => 'Description de l\'entreprise';

  @override
  String get psBusinessDescHint => 'Brève description de votre entreprise';

  @override
  String get psCategoryTags => 'Étiquettes de catégorie';

  @override
  String get psEditProfile => 'Modifier votre profil';

  @override
  String get psPersonalDetails => 'Détails personnels';

  @override
  String get psBusinessDetails => 'Détails de l\'entreprise';

  @override
  String get psMonthJan => 'Janvier';

  @override
  String get psMonthFeb => 'Février';

  @override
  String get psMonthMar => 'Mars';

  @override
  String get psMonthApr => 'Avril';

  @override
  String get psMonthMay => 'Mai';

  @override
  String get psMonthJun => 'Juin';

  @override
  String get psMonthJul => 'Juillet';

  @override
  String get psMonthAug => 'Août';

  @override
  String get psMonthSep => 'Septembre';

  @override
  String get psMonthOct => 'Octobre';

  @override
  String get psMonthNov => 'Novembre';

  @override
  String get psMonthDec => 'Décembre';

  @override
  String get psSecurity => 'Sécurité';

  @override
  String get psChangePassword => 'Changer le mot de passe';

  @override
  String get psChangePasswordSub =>
      'Mettez à jour votre mot de passe de connexion.';

  @override
  String get ps2faTitle => 'Authentification 2FA';

  @override
  String get ps2faSub => 'Ajoutez une couche de sécurité supplémentaire.';

  @override
  String get psNewPassword => 'Nouveau mot de passe';

  @override
  String get psNewPasswordHint => 'Saisir le nouveau mot de passe';

  @override
  String get psConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get psConfirmPasswordHint => 'Confirmer le nouveau mot de passe';

  @override
  String get psReqCapital => 'Doit contenir une lettre majuscule';

  @override
  String get psReqNumber => 'Doit contenir un chiffre, ex. 1,2,4,etc';

  @override
  String get psReqSpecial =>
      'Doit contenir un caractère spécial, ex. @,\$,%,etc';

  @override
  String get psSavePassword => 'Enregistrer le mot de passe';

  @override
  String get psPasswordSaved => 'Mot de passe enregistré';

  @override
  String get psTheme => 'Thème';

  @override
  String get psSelectDisplay => 'Sélectionnez votre affichage préféré';

  @override
  String get psThemeLight => 'Clair';

  @override
  String get psThemeDark => 'Sombre';

  @override
  String get psThemeSystem => 'Système';

  @override
  String get psSavePreference => 'Enregistrer la préférence';

  @override
  String get psThemeSaved => 'Préférence de thème enregistrée';

  @override
  String get psNotification => 'Notification';

  @override
  String get psChannelNone => 'Aucun';

  @override
  String get psChannelInApp => 'Dans l\'app';

  @override
  String get psChannelEmail => 'E-mail';

  @override
  String get psChannelBoth => 'Les deux';

  @override
  String get psAllNotifications => 'Toutes les notifications';

  @override
  String get psChooseWhere =>
      'Choisissez où vous souhaitez recevoir les notifications';

  @override
  String get psNotifAllMessages => 'Tous les messages';

  @override
  String get psNotifAllMessagesSub => 'quelqu\'un répond à votre message';

  @override
  String get psNotifOrderDelivery => 'Chronologie commande / livraison';

  @override
  String get psNotifOrderDeliverySub =>
      'soyez notifié lorsqu\'une commande est reçue / terminée';

  @override
  String get psNotifEventTimeline => 'Chronologie de l\'événement';

  @override
  String get psNotifEventTimelineSub =>
      'soyez notifié lorsqu\'il y a une nouvelle chronologie d\'événement';

  @override
  String get psNotifPayment => 'Alertes de paiement';

  @override
  String get psNotifPaymentSub => 'soyez notifié lorsqu\'un paiement réussit';

  @override
  String get psNotifQuoteInvoice => 'Alertes devis / facture';

  @override
  String get psNotifQuoteInvoiceSub =>
      'soyez notifié lorsque votre devis est traité';

  @override
  String get psLinkedBankAccount => 'Compte bancaire lié';

  @override
  String get psWhereClientsPay => 'Où les clients vous paient directement';

  @override
  String get psAddBankAccount => 'Ajouter un compte bancaire';

  @override
  String get psChangeBankAccount => 'Changer de compte bancaire';

  @override
  String get psNoBankYet => 'Aucun compte bancaire pour le moment';

  @override
  String get psNoBankBody =>
      'Ajoutez-en un pour que les clients puissent vous payer directement lorsqu\'ils acceptent vos devis.';

  @override
  String get psBankFallback => 'Banque';

  @override
  String get psReadyToReceive => 'Prêt à recevoir des paiements';

  @override
  String get psSettingUp => 'Configuration…';

  @override
  String get psReasonNoNeed => 'Je n\'ai plus besoin du service';

  @override
  String get psReasonBetter => 'J\'ai trouvé une meilleure plateforme';

  @override
  String get psReasonTech => 'Trop de problèmes techniques';

  @override
  String get psReasonPrivacy => 'Préoccupations de confidentialité';

  @override
  String get psReasonOther => 'Autre';

  @override
  String get psSelectReason => 'Sélectionnez une raison';

  @override
  String get psDeleteConfirmTitle => 'Êtes-vous sûr de vouloir supprimer';

  @override
  String get psDeleteBullet1 => 'L\'accès à vos réservations actives';

  @override
  String get psDeleteBullet2 =>
      'L\'accès à vos données de compte et identifiants';

  @override
  String get psDeleteBullet3 => 'Les informations de connexion';

  @override
  String get psDeleteBullet4 =>
      'Tous les contacts clients par message et appel';

  @override
  String get psYesConfirm => 'Oui, confirmer';

  @override
  String get psNotYet => 'Pas encore';

  @override
  String get psSuccessful => 'Réussi';

  @override
  String get psDeleteSuccessBody =>
      'Votre compte a été supprimé avec succès. Nous sommes désolés de vous voir partir et espérons vous revoir bientôt';

  @override
  String get psCloseApp => 'Fermer l\'application';

  @override
  String get psDeleteAccount => 'Supprimer le compte';

  @override
  String get psYourAccount => 'Votre compte';

  @override
  String get psTellReason =>
      'Dites-nous la raison de la suppression de votre compte';

  @override
  String get psSelectOption => 'Sélectionnez une option';

  @override
  String get psOtherReasons => 'Autres raisons';

  @override
  String get psTypeMessage => 'Saisissez votre message';

  @override
  String get psDeactivateAccount => 'Désactiver le compte';

  @override
  String get psAccountDeactivated => 'Compte désactivé';

  @override
  String psTrialStarted(String name) {
    return 'Votre essai gratuit $name a commencé 🎉';
  }

  @override
  String psNowOnPlan(String name) {
    return 'Vous êtes maintenant sur le forfait $name';
  }

  @override
  String get psPaymentCancelled =>
      'Paiement annulé — votre forfait est inchangé';

  @override
  String psPaymentConfirmed(String name) {
    return 'Paiement confirmé — vous êtes maintenant sur le forfait $name';
  }

  @override
  String get psSubscriptionPlan => 'Forfait d\'abonnement';

  @override
  String get psChoosePlan =>
      'Choisissez le forfait adapté à votre entreprise. Améliorez ou changez à tout moment.';

  @override
  String get psOnTrial => 'En essai';

  @override
  String get psCurrent => 'Actuel';

  @override
  String psSwitchTo(String name) {
    return 'Passer à $name';
  }

  @override
  String psUpgradeTo(String name) {
    return 'Améliorer vers $name';
  }

  @override
  String reviewsReplyTo(String name) {
    return 'Répondre à $name';
  }

  @override
  String get reviewsReplyHint =>
      'Remerciez-les ou répondez à leurs commentaires…';

  @override
  String get reviewsSending => 'Envoi…';

  @override
  String get reviewsSendReply => 'Envoyer la réponse';

  @override
  String get reviewsMyReviews => 'Mes avis';

  @override
  String get reviewsSubtitle =>
      'Les avis que vous avez reçus pour vos travaux passés';

  @override
  String get reviewsLoadFailed => 'Impossible de charger les avis';

  @override
  String get reviewsEmpty => 'Aucun avis pour le moment';

  @override
  String get reviewsEmptyBody =>
      'Terminez des réservations et les avis de vos clients apparaîtront ici.';

  @override
  String reviewsCount(int total) {
    return '($total avis)';
  }

  @override
  String reviewsMonthsAgo(int count) {
    return 'il y a $count mois';
  }

  @override
  String reviewsDaysAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String reviewsHoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String get reviewsJustNow => 'à l\'instant';

  @override
  String get reviewsReply => 'Répondre';

  @override
  String get reviewsYourReply => 'Votre réponse';

  @override
  String get termsRowTitle => 'Conditions générales';

  @override
  String get termsLastUpdated => 'Dernière mise à jour le 17 avril 2025';

  @override
  String get termsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get termsPrivacySubtitle => 'Lisez notre accord de confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get galleryPhoto1 => 'Photo principale';

  @override
  String get galleryPhoto2 => 'Deuxième photo';

  @override
  String get galleryPhoto3 => 'Troisième photo';

  @override
  String get galleryPhoto4 => 'Quatrième photo';

  @override
  String galleryUploadFailed(String error) {
    return 'Impossible de téléverser la photo : $error';
  }

  @override
  String get gallerySaved => 'Galerie enregistrée';

  @override
  String gallerySaveFailed(String error) {
    return 'Impossible d\'enregistrer la galerie : $error';
  }

  @override
  String get gallerySubtitle =>
      'Mettez en valeur vos meilleurs travaux pour attirer des clients';

  @override
  String get gallerySaveButton => 'Enregistrer la galerie';

  @override
  String get supportTitle => 'Assistance';

  @override
  String supportGreeting(String name) {
    return 'Bonjour, $name 👋';
  }

  @override
  String get supportThere => 'vous';

  @override
  String get supportSearchHint => 'Comment pouvons-nous vous aider ?';

  @override
  String get supportPromoTitle => 'Système d\'assistance de premier ordre';

  @override
  String get supportPromoSub =>
      'Obtenez des réponses rapides via notre chat en ligne';

  @override
  String get supportFaqTitle => 'Foire aux questions';

  @override
  String get supportViewMore => 'Voir plus de questions';

  @override
  String get supportChat => 'Chat';

  @override
  String get supportChatSub => 'Besoin d\'aide ? Nous sommes là pour vous';

  @override
  String get supportCallSupport => 'Appeler l\'assistance';

  @override
  String get supportCallHours => 'Disponible du lun. au ven., 9h - 17h';

  @override
  String get supportFaqQ1 => 'Comment créer une annonce ?';

  @override
  String get supportFaqQ2 => 'Comment gérer les réservations ?';

  @override
  String get supportFaqQ3 => 'Comment les clients paient-ils mes services ?';

  @override
  String get supportFaqQ4 => 'Comment retirer mes revenus ?';

  @override
  String get supportFaqQ5 => 'Quels frais Planovar facture-t-il ?';

  @override
  String get supportFaqQ6 => 'Comment vérifier mon compte ?';

  @override
  String get supportFaqQ7 => 'Puis-je annuler une réservation ?';

  @override
  String get supportFaqQ8 => 'Comment fonctionnent les avis ?';

  @override
  String get supportFaqQ9 => 'Comment améliorer mon abonnement ?';

  @override
  String get supportFaqQ10 => 'Comment contacter un client ?';

  @override
  String supportQuestionN(int number) {
    return 'Question $number';
  }

  @override
  String get supportNeedMoreHelp => 'J\'ai besoin de plus d\'aide';

  @override
  String get supportChatWithUs => 'Discuter avec nous';

  @override
  String get supportCallUs => 'Appelez-nous';

  @override
  String get supportCallAvailable =>
      'Nous sommes disponibles du lundi au vendredi de 9h à 17h';

  @override
  String get supportLiveSupport => 'Assistance en direct';

  @override
  String get supportReplyMinutes =>
      'Nous répondons généralement en quelques minutes';

  @override
  String get supportChatSetup =>
      'Le chat en direct est en cours de configuration';

  @override
  String get supportChatSetupMsg =>
      'Notre chat en direct n\'est pas encore connecté. En attendant, envoyez-nous un e-mail et nous vous répondrons rapidement.';

  @override
  String get supportEmailSupport => 'Envoyer un e-mail à l\'assistance';

  @override
  String get supportChatTeam => 'Discutez avec notre équipe';

  @override
  String get supportChatTeamMsg =>
      'Ouvrez notre chat en direct pour parler à un agent d\'assistance.';

  @override
  String get supportOpenChat => 'Ouvrir le chat en direct';

  @override
  String get twofaIntroTitle => 'Activez la 2FA pour plus de sécurité';

  @override
  String get twofaGetStarted => 'Commencer';

  @override
  String get twofaSetupTitle => 'Configuration 2FA';

  @override
  String get twofaSetUpUsing => 'Configurer avec';

  @override
  String get twofaAuthenticatorHint =>
      'À l\'aide d\'une application d\'authentification comme (Google Authenticator, Authy, 1Password, LastPass, etc.)';

  @override
  String get twofaScanMe => 'Scannez-moi';

  @override
  String get twofaCantScan =>
      'Si vous ne pouvez pas scanner le code QR ci-dessus, saisissez plutôt ce texte';

  @override
  String get twofaConfirmCode => 'Confirmer le code';

  @override
  String get twofaEnterCode =>
      'Saisissez le code fourni par l\'application d\'authentification';

  @override
  String get twofaConfirm => 'Confirmer';

  @override
  String get twofaAllPrefix => 'Tout est ';

  @override
  String get twofaDoneWord => 'terminé';

  @override
  String get twofaSuccessBody => 'Votre 2FA a été activée avec succès';

  @override
  String get twofaBackToProfile => 'Retour à la configuration du profil';

  @override
  String get analyticsTitle => 'Analytique';

  @override
  String get analyticsActiveListings => 'Annonces actives';

  @override
  String analyticsOfTotal(int total) {
    return 'sur $total au total';
  }

  @override
  String get analyticsInquiries => 'Demandes';

  @override
  String analyticsAwaitingReply(int count) {
    return '$count en attente de réponse';
  }

  @override
  String get analyticsRating => 'Note';

  @override
  String analyticsReviews(int count) {
    return '$count avis';
  }

  @override
  String get analyticsPlan => 'Forfait';

  @override
  String get analyticsDetailedTitle => 'Analytique de performance détaillée';

  @override
  String get analyticsComingSoon =>
      'Les tendances, les vues de profil et les graphiques de conversion arrivent bientôt.';

  @override
  String get payoutsTitle => 'Paiements';

  @override
  String get payoutsHeadline => 'Vous gardez 100 % de ce que vous gagnez';

  @override
  String get payoutsBody =>
      'Planovar fonctionne sur abonnement — nous ne détenons pas votre argent et ne prenons pas de commission. Les clients vous paient directement, selon ce que vous convenez ensemble.';

  @override
  String get notifMarkAllRead => 'Tout marquer comme lu';

  @override
  String get notifEmpty => 'Aucune notification';

  @override
  String get notifFilterAll => 'Toutes';

  @override
  String get notifFilterOrders => 'Commandes';

  @override
  String get notifFilterPayments => 'Paiements';

  @override
  String get notifFilterSystem => 'Système';

  @override
  String get notifToday => 'Aujourd\'hui';

  @override
  String get notifYesterday => 'Hier';

  @override
  String get notifEarlier => 'Plus tôt';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusConfirmed => 'Confirmé';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get statusSent => 'Envoyé';

  @override
  String get statusAccepted => 'Accepté';

  @override
  String get statusRejected => 'Rejeté';

  @override
  String get statusDeclined => 'Refusé';

  @override
  String get statusPaid => 'Payé';

  @override
  String get statusFailed => 'Échoué';

  @override
  String get statusFeatured => 'En vedette';

  @override
  String get statusPremium => 'Premium';

  @override
  String get statusBasic => 'Basique';

  @override
  String get statusExpired => 'Expiré';

  @override
  String get statusSuperseded => 'Remplacé';

  @override
  String get statusPartiallyPaid => 'Partiellement payé';

  @override
  String get ccQuote => 'Devis';

  @override
  String ccValidTill(String date) {
    return 'Valable jusqu\'au $date';
  }

  @override
  String get ccTotal => 'Total';

  @override
  String ccInvoiceNumber(String number) {
    return 'Facture · $number';
  }

  @override
  String get ccOrderRequest => 'Demande de commande';

  @override
  String get ccClientRequesting =>
      'Le client le demande — acceptez pour envoyer une facture';

  @override
  String get ccDecline => 'Refuser';

  @override
  String get ccAccept => 'Accepter';

  @override
  String ccDue(String date) {
    return 'Échéance $date';
  }

  @override
  String get ccTaskDone => 'Vous avez terminé votre tâche';

  @override
  String get ccMarkTaskDone => 'Marquer votre tâche comme terminée';

  @override
  String get errorSomethingWrong => 'Une erreur s\'est produite';

  @override
  String get errorTryAgain => 'Réessayer';

  @override
  String get bankAdded =>
      'Compte bancaire ajouté — vous pouvez maintenant recevoir des paiements 🎉';

  @override
  String get bankClientsPayDirect =>
      'Les clients vous paient directement sur ce compte.';

  @override
  String get bankLoading => 'Chargement des banques…';

  @override
  String get bankSelect => 'Sélectionner une banque';

  @override
  String get bankAccountNumberHint => 'Numéro de compte à 10 chiffres';

  @override
  String get bankVerifying => 'Vérification du compte…';

  @override
  String get bankSaving => 'Enregistrement…';

  @override
  String get bankSaveAccount => 'Enregistrer le compte';

  @override
  String get bankSearch => 'Rechercher une banque';

  @override
  String get planPopular => 'POPULAIRE';

  @override
  String get planCurrentPlan => 'Forfait actuel';

  @override
  String get planMonthly => 'Mensuel';

  @override
  String get planYearly => 'Annuel';

  @override
  String get qrcNew => 'Nouveau';

  @override
  String qrcBudget(String amount) {
    return 'Budget : $amount';
  }

  @override
  String get qrcBudgetTbd => 'Budget : à définir';

  @override
  String get qrcOpenRespond => 'Ouvrir et répondre';

  @override
  String get qrcReject => 'Rejeter';

  @override
  String get tagAddMore => 'Ajouter un tag...';

  @override
  String tagHelper(int count, int max) {
    return 'Appuyez sur virgule ou Entrée pour ajouter un tag  ·  $count/$max';
  }

  @override
  String get psCurrentPassword => 'Mot de passe actuel';

  @override
  String get psCurrentPasswordHint => 'Saisissez votre mot de passe actuel';

  @override
  String get psCurrentPasswordRequired =>
      'Veuillez saisir votre mot de passe actuel';

  @override
  String get psPasswordTooWeak =>
      'Votre nouveau mot de passe doit contenir au moins 8 caractères, dont une majuscule, un chiffre et un caractère spécial';

  @override
  String get psPasswordsDontMatch =>
      'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get tfaChallengeTitle => 'Authentification à deux facteurs';

  @override
  String get tfaChallengeSubtitle =>
      'Saisissez le code à 6 chiffres de votre application d\'authentification';

  @override
  String get tfaVerify => 'Vérifier';

  @override
  String get twofaDisable => 'Désactiver la double authentification';

  @override
  String get twofaConfirmPasswordTitle => 'Confirmez votre mot de passe';

  @override
  String get twofaContinue => 'Continuer';

  @override
  String get twofaDisabled => 'Double authentification désactivée';

  @override
  String get twofaSecretCopied => 'Clé de configuration copiée';

  @override
  String get twofaBackupCodesTitle => 'Codes de secours';

  @override
  String get twofaBackupCodesHint =>
      'Conservez-les en lieu sûr — chacun peut être utilisé une fois si vous perdez votre authentificateur.';

  @override
  String get cqAfterEvent => 'Après l\'événement';
}
