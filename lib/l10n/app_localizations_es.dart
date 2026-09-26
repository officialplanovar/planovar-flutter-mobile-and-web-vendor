// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get languageIntro =>
      'Elige tu idioma preferido. El inglés ya está disponible; pronto habrá más.';

  @override
  String get comingSoon => 'Pronto';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get retry => 'Reintentar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get search => 'Buscar';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get navHome => 'Inicio';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navMessages => 'Mensajes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navListings => 'Anuncios';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToContinue =>
      'Inicia sesión para continuar tu recorrido en Planovar';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get emailHint => 'Introduce tu correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Introduce la contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get orLabel => 'o';

  @override
  String get noAccountQuestion => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get onboardingTitle1 => 'Accede a miles de clientes de eventos';

  @override
  String get onboardingSubtitle1 =>
      'Conecta con parejas, empresas y organizadores de eventos de tu zona que buscan activamente proveedores como tú';

  @override
  String get onboardingTitle2 => 'Gestiona todo en un solo panel';

  @override
  String get onboardingSubtitle2 =>
      'Haz seguimiento de tus consultas, reservas y conversaciones desde un único espacio de trabajo';

  @override
  String get onboardingTitle3 => 'Muestra tu trabajo y hazte notar';

  @override
  String get onboardingSubtitle3 =>
      'Publica tus productos, servicios y alquileres; luego suscríbete para subir en las clasificaciones de búsqueda y llegar antes a los organizadores de eventos.';

  @override
  String get onboardingListBusiness => 'Publicar mi negocio';

  @override
  String get onboardingHaveAccount => 'Ya tengo una cuenta';

  @override
  String get loginSubtitle => 'Inicia sesión en tu cuenta de proveedor';

  @override
  String get emailPlaceholder => 'tunombre@negocio.com';

  @override
  String get loginPasswordHint => 'Introduce tu contraseña';

  @override
  String get registerTitle => 'Crea tu cuenta de proveedor';

  @override
  String get registerSubtitle => 'Empieza a publicar tu negocio en Planovar';

  @override
  String get firstName => 'Nombre';

  @override
  String get firstNameHint => 'p. ej. Ada';

  @override
  String get lastName => 'Apellido';

  @override
  String get lastNameHint => 'p. ej. Obi';

  @override
  String get businessName => 'Nombre del negocio';

  @override
  String get businessNameHint => 'p. ej. Sugared Dreams Cakery';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get dobPlaceholder => 'DD / MM / AAAA';

  @override
  String get selectDob => 'Selecciona tu fecha de nacimiento';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get phoneNumberHint => '8012345678';

  @override
  String get createPassword => 'Crear contraseña';

  @override
  String get createPasswordHint => 'Mín. 8 caracteres';

  @override
  String get registerAgreePrefix => 'Al marcar la casilla aceptas nuestros ';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get registerAgreeAnd => ' y ';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get signInAction => 'Iniciar sesión';

  @override
  String get forgotResetTitle => 'Restablece tu contraseña';

  @override
  String get forgotResetIntro =>
      'Introduce tu correo electrónico y te enviaremos un código de 6 dígitos para restablecer tu contraseña.';

  @override
  String forgotResetSentTo(String email) {
    return 'Se ha enviado un código de restablecimiento a $email. Revisa tu bandeja de entrada.';
  }

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get sendResetCode => 'Enviar código de restablecimiento';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String get resetPasswordTitle => 'Restablecer contraseña';

  @override
  String get resetPasswordSuccess =>
      'Contraseña restablecida correctamente. Inicia sesión.';

  @override
  String get resetCreateNewPassword => 'Crea una nueva contraseña';

  @override
  String get resetCodeSentTo => 'Introduce el código de 6 dígitos enviado a ';

  @override
  String get resetChoosePassword => ' y elige una nueva contraseña.';

  @override
  String get verificationCode => 'Código de verificación';

  @override
  String get sixDigitCode => 'Código de 6 dígitos';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get atLeast8Chars => 'Al menos 8 caracteres';

  @override
  String get mustBeAtLeast8Chars => 'Debe tener al menos 8 caracteres';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Vuelve a introducir tu nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get verifyEmailTitle => 'Verifica tu correo electrónico';

  @override
  String get verifyEmailIntro =>
      'Hemos enviado un OTP de 6 dígitos a tu correo electrónico';

  @override
  String get verifyNewCodeSent => 'Se ha enviado un nuevo código';

  @override
  String verifyCouldNotResend(String error) {
    return 'No se pudo reenviar el código: $error';
  }

  @override
  String get proceed => 'Continuar';

  @override
  String verifyResendIn(int seconds) {
    return 'Reenviar código en $seconds s';
  }

  @override
  String get resendCodeAction => 'Reenviar código';

  @override
  String get setupBusinessSetup => 'Configuración del negocio';

  @override
  String get setupBusinessProfileTitle => 'Perfil del negocio';

  @override
  String get setupBusinessProfileSubtitle =>
      'Cuéntales a los clientes quién eres';

  @override
  String get setupLicensedBusiness => 'Negocio registrado';

  @override
  String get setupLicensedBusinessDesc =>
      'Empresa, agencia o estudio registrado';

  @override
  String get setupFreelancer => 'Autónomo';

  @override
  String get setupFreelancerDesc =>
      'Persona que ofrece servicios profesionales';

  @override
  String get setupCouldNotLoadCategories =>
      'No se pudieron cargar las categorías';

  @override
  String get setupCouldNotReadFile => 'No se pudo leer el archivo seleccionado';

  @override
  String get setupFileTooLarge => 'El archivo supera los 5 MB';

  @override
  String get setupBusinessLogoOptional => 'Logotipo del negocio (opcional)';

  @override
  String get setupBusinessDescription => 'Descripción del negocio';

  @override
  String get setupBusinessDescriptionHint =>
      'Cuéntales a los clientes qué hace especial a tu negocio, tu experiencia y lo que ofreces...';

  @override
  String get setupProofOfOwnership => 'Prueba de propiedad';

  @override
  String get setupProofOptionalFreelancers => '(opcional para autónomos)';

  @override
  String get setupDocumentUploaded => 'Documento subido';

  @override
  String get setupTapToReplace => 'Toca para reemplazar';

  @override
  String get setupTapToUpload => 'Toca para subir';

  @override
  String get setupUploadFileTypes => 'JPG, PNG o PDF de hasta 5 MB';

  @override
  String get setupCategoryTags => 'Etiquetas de categoría';

  @override
  String get setupNoCategories => 'Aún no hay categorías disponibles';

  @override
  String get setupLocationTitle => 'Ubicación y alcance';

  @override
  String get setupLocationSubtitle => '¿Dónde operas?';

  @override
  String get setupTurnOnLocation =>
      'Activa los servicios de ubicación para usar esto.';

  @override
  String get setupLocationDenied =>
      'Permiso de ubicación denegado: elige tu ciudad manualmente.';

  @override
  String get setupCouldNotDetermineCity =>
      'No pudimos determinar tu ciudad: elígela manualmente.';

  @override
  String get setupCouldNotGetLocation =>
      'No pudimos obtener tu ubicación. Elige tu ciudad manualmente.';

  @override
  String get selectCountry => 'Selecciona el país';

  @override
  String get selectCity => 'Selecciona la ciudad';

  @override
  String get selectYourCity => 'Selecciona tu ciudad';

  @override
  String get country => 'País';

  @override
  String get city => 'Ciudad';

  @override
  String get setupLocating => 'Localizando…';

  @override
  String get setupUseCurrentLocation => 'Usar mi ubicación actual';

  @override
  String get setupVendorType => 'Tipo de proveedor';

  @override
  String get setupProductsOnly => 'Solo productos';

  @override
  String get setupServicesOnly => 'Solo servicios';

  @override
  String get setupBothProductsServices => 'Productos y servicios';

  @override
  String get setupChoosePlanTitle => 'Elige tu plan';

  @override
  String get setupChoosePlanSubtitle =>
      'Mejora en cualquier momento. Cancela cuando quieras.';

  @override
  String get setupCouldNotLoadPlans =>
      'No se pudieron cargar los planes. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String setupSelectPlan(String plan) {
    return 'Seleccionar $plan';
  }

  @override
  String get setupSkipForNow => 'Omitir por ahora';

  @override
  String get setupVerifyIdentityTitle => 'Verifica tu identidad';

  @override
  String get setupVerifyIdentitySubtitle =>
      'Sube una identificación oficial con foto, y tu registro de empresa si tienes un negocio registrado. Se almacena de forma segura.';

  @override
  String get setupUploaded => 'Subido';

  @override
  String get setupUploadNin => 'Sube tu identificación oficial';

  @override
  String get setupUploadCac => 'Sube tu registro de empresa';

  @override
  String get setupIdTypeLabel => 'Tipo de identificación';

  @override
  String get idTypePassport => 'Pasaporte';

  @override
  String get idTypeNationalId => 'Documento nacional de identidad';

  @override
  String get idTypeDriversLicense => 'Licencia de conducir';

  @override
  String get setupPaymentNotCompleted =>
      'Pago no completado: puedes suscribirte a un plan de pago en cualquier momento desde tu perfil.';

  @override
  String get setupSomethingWentWrong => 'Algo salió mal';

  @override
  String get setupSettingUp => 'Configurando…';

  @override
  String get setupFinishSetup => 'Finalizar configuración';

  @override
  String get setupCompleteVerificationLater =>
      'Puedes completar la verificación más tarde desde tu perfil.';

  @override
  String get selectBank => 'Selecciona el banco';

  @override
  String get setupPayoutTitle => 'Datos de pago';

  @override
  String get setupPayoutSubtitle => '¿A dónde enviamos tus ganancias?';

  @override
  String get setupBankName => 'Nombre del banco';

  @override
  String get setupSelectYourBank => 'Selecciona tu banco';

  @override
  String get setupAccountNumber => 'Número de cuenta';

  @override
  String get setupAccountNumberHint => '0123456789';

  @override
  String get setupAccountName => 'Nombre de la cuenta';

  @override
  String get setupAutoVerified => 'Verificado automáticamente';

  @override
  String get setupPayoutSchedule => 'Calendario de pagos';

  @override
  String get setupPayoutRolling => 'Continuo · 24–48 h tras la finalización';

  @override
  String get setupPayoutCommission =>
      'Comisión de la plataforma · Deducida antes del pago';

  @override
  String get setupMinimumPayout => 'Pago mínimo · \$1,000';

  @override
  String get setupSecuredByPaystack => 'Protegido por Paystack';

  @override
  String get setupSavePayoutDetails => 'Guardar datos de pago';

  @override
  String get setupAllSet => '¡Todo listo!';

  @override
  String get setupProfileLive =>
      'Tu perfil de proveedor ya está activo en Planovar. Empieza a añadir tus productos y servicios para llegar a miles de organizadores de eventos de todo el mundo.';

  @override
  String get setupAddFirstListing => 'Añade tu primer anuncio';

  @override
  String get setupAddFirstListingSub => 'Productos, servicios o alquileres';

  @override
  String get setupUpgradePlan => 'Mejora tu plan';

  @override
  String get setupUpgradePlanSub => 'Consigue más visibilidad y analíticas';

  @override
  String get setupGoToDashboard => 'Ir al panel';

  @override
  String get payCompletePayment => 'Completar el pago';

  @override
  String get paySecurePayment => 'Pago seguro';

  @override
  String get payBrowserFailed =>
      'No pudimos abrir tu navegador. Toca abajo para abrir el pago seguro de Paystack.';

  @override
  String get payBrowserOpened =>
      'Hemos abierto el pago seguro de Paystack en tu navegador. Finaliza tu pago ahí, luego vuelve y toca el botón de abajo.';

  @override
  String get payOpenPaymentPage => 'Abrir página de pago';

  @override
  String get payReopenPaymentPage => 'Reabrir página de pago';

  @override
  String get payCompletedPayment => 'He completado el pago';

  @override
  String get homeLocationNotSet => 'Ubicación no definida';

  @override
  String get homeTodaysSchedule => 'Agenda de hoy';

  @override
  String get homeQuickAction => 'Acción rápida';

  @override
  String get viewAll => 'Ver todo';

  @override
  String homeNewRequestsAttention(int count) {
    return '$count solicitudes nuevas necesitan tu atención';
  }

  @override
  String homeNewRequestsSubtitle(int count) {
    return 'Tienes $count solicitudes nuevas para tus anuncios';
  }

  @override
  String get homeConfirmedBookings => 'Reservas confirmadas';

  @override
  String get homePendingRequests => 'Solicitudes pendientes';

  @override
  String get homeThisMonth => 'Este mes';

  @override
  String homeBookingsCount(int count) {
    return '$count reservas';
  }

  @override
  String get homeAvgRating => 'Valoración media';

  @override
  String homeFromReviews(int count) {
    return 'de $count reseñas';
  }

  @override
  String get homeNoSchedule => 'No hay agenda para hoy';

  @override
  String get homeAddListing => 'Añadir anuncio';

  @override
  String get homeAnalytics => 'Analíticas';

  @override
  String get homeUpgradePlanShort => 'Mejorar plan';

  @override
  String get homePayouts => 'Pagos';

  @override
  String get homeGoodMorning => 'Buenos días,';

  @override
  String get homeGoodAfternoon => 'Buenas tardes,';

  @override
  String get homeGoodEvening => 'Buenas noches,';

  @override
  String get listingTypeTitle => 'Tipo de anuncio';

  @override
  String get listingTypeSubtitle =>
      'Selecciona el tipo de anuncio que quieres crear';

  @override
  String get listingTypeService => 'Servicio';

  @override
  String get listingTypeServiceDesc => 'cita reservable';

  @override
  String get listingTypeProduct => 'Producto';

  @override
  String get listingTypeProductDesc => 'Artículo físico para alquiler o venta';

  @override
  String get homeActionNeeded => 'Acción necesaria';

  @override
  String get homeAllCaughtUp => 'Estás al día';

  @override
  String get homeNoInquiriesWaiting =>
      'No hay consultas esperando tu respuesta.';

  @override
  String get homeNewInquiry => 'Nueva consulta';

  @override
  String get homeNewBadge => 'Nuevo';

  @override
  String get homeOpenRespond => 'Abrir y responder';

  @override
  String get addListingNewListing => 'Nuevo anuncio';

  @override
  String get addListingServiceDesc => 'Cita reservable';

  @override
  String get addSuccessSuccessfully => 'Correctamente';

  @override
  String addSuccessAddedTitle(String label) {
    return '$label añadido ';
  }

  @override
  String addSuccessPendingSubtitle(String label) {
    return 'Tu $label se ha guardado. Será visible para los clientes una vez que tu cuenta esté verificada.';
  }

  @override
  String get addSuccessLiveService =>
      'Tu servicio se ha añadido correctamente y ya está activo';

  @override
  String get addSuccessLiveProduct =>
      'Tu producto se ha añadido correctamente y ya está activo';

  @override
  String get addSuccessPendingWarning =>
      'Pendiente de verificación: los clientes no pueden ver tus anuncios hasta que un administrador verifique tu cuenta. Te avisaremos cuando estés aprobado.';

  @override
  String addSuccessIdLabel(String label) {
    return 'ID de $label';
  }

  @override
  String get addSuccessSku => 'SKU';

  @override
  String get addSuccessDateCreated => 'Fecha de creación';

  @override
  String addSuccessViewLabel(String label) {
    return 'Ver $label';
  }

  @override
  String get listingBadgeProductRental => 'Producto (Alquiler)';

  @override
  String listingPerDay(String price) {
    return '$price / día';
  }

  @override
  String get listingQuoteBased => 'Según presupuesto';

  @override
  String get listingsMyListings => 'Mis anuncios';

  @override
  String listingsTabAll(int count) {
    return 'Todos ($count)';
  }

  @override
  String listingsTabServices(int count) {
    return 'Servicios ($count)';
  }

  @override
  String listingsTabProducts(int count) {
    return 'Productos ($count)';
  }

  @override
  String listingsTabRentals(int count) {
    return 'Alquileres ($count)';
  }

  @override
  String listingsOutOfStockCount(int count) {
    return '$count artículos están agotados, ';
  }

  @override
  String get listingsClickToUpdate => 'Haz clic para actualizar';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusInactive => 'Inactivo';

  @override
  String get listingsPendingReview => 'Pendiente de revisión';

  @override
  String get listingsEmptyTitle => 'Aún no hay anuncios aquí';

  @override
  String get listingsEmptySubtitle => 'Toca + para añadir tu primer anuncio';

  @override
  String get listingsAddListing => 'Añadir anuncio';

  @override
  String get listingsCouldNotLoad => 'No se pudieron cargar tus anuncios';

  @override
  String get oosTitle => 'Anuncios agotados';

  @override
  String get oosRental => 'Alquiler';

  @override
  String oosReactivated(String noun) {
    return '$noun reactivado';
  }

  @override
  String get oosBadge => 'Agotado';

  @override
  String get oosRestock => 'Reponer';

  @override
  String get oosEmptyTitle => '¡Todos los anuncios tienen stock!';

  @override
  String get oosEmptySubtitle => 'No hay artículos agotados en esta categoría';

  @override
  String get category => 'Categoría';

  @override
  String get selectCategory => 'Selecciona la categoría';

  @override
  String get apGenerateSkuHint =>
      'Introduce primero el nombre del producto y luego genera un SKU.';

  @override
  String get apNameDescRequired =>
      'El nombre y la descripción del producto son obligatorios';

  @override
  String get apSelectCategory => 'Selecciona una categoría';

  @override
  String get apSelectACategory => 'Selecciona una categoría';

  @override
  String get apNoCategoriesProfile =>
      'Aún no has añadido ninguna categoría a tu perfil. Añádelas en Perfil → Datos del negocio para publicar productos aquí.';

  @override
  String get apOnlyRegisteredCategories =>
      'Solo se muestran tus categorías registradas. Añade más en Perfil → Datos del negocio.';

  @override
  String get apForSale => 'En venta';

  @override
  String get apForRent => 'En alquiler';

  @override
  String get apTitle => 'Añadir un producto';

  @override
  String get apSubtitle => 'Añade un producto a tu catálogo';

  @override
  String get apProductName => 'Nombre del producto';

  @override
  String get apProductNameHint => 'Introduce el nombre del producto...';

  @override
  String get apProductDescription => 'Descripción del producto';

  @override
  String get apProductDescriptionHint => 'Describe tu producto...';

  @override
  String get apProductPrice => 'Precio del producto';

  @override
  String get apPricePerDay => 'Precio por día';

  @override
  String get apRefundableDeposit => 'Depósito reembolsable';

  @override
  String get apRentalDuration => 'Duración del alquiler (días)';

  @override
  String get apRentalDurationHint => 'p. ej. 3';

  @override
  String get apSkuHint => 'Introduce el SKU del producto...';

  @override
  String get apGenerateForMe => 'Generar por mí';

  @override
  String get apQuantityInStock => 'Cantidad en stock';

  @override
  String get apQuantityHint => 'Cuántos tienes en stock';

  @override
  String get apAvailableSizes => 'Tallas disponibles (opcional)';

  @override
  String get apTags => 'Etiquetas';

  @override
  String get apTagsHint => 'p. ej. Boda, Pastel, Lujo';

  @override
  String get apProductPhotos => 'Fotos del producto';

  @override
  String get apFrontPhoto => 'Foto frontal';

  @override
  String get apBackPhoto => 'Foto trasera';

  @override
  String get apSidePhoto => 'Foto lateral';

  @override
  String get apDetailPhoto => 'Foto de detalle';

  @override
  String get apPublishing => 'Publicando…';

  @override
  String get apPublishProduct => 'Publicar producto';

  @override
  String get gotIt => 'Entendido';

  @override
  String get asNameDescRequired =>
      'El nombre y la descripción del servicio son obligatorios';

  @override
  String get asNoCategoriesProfile =>
      'Aún no has añadido ninguna categoría a tu perfil. Añádelas en Perfil → Datos del negocio para publicar servicios aquí.';

  @override
  String get asCancellationPolicy => 'Política de cancelación';

  @override
  String get policyFlexible => 'Flexible';

  @override
  String get policyModerate => 'Moderada';

  @override
  String get policyStrict => 'Estricta';

  @override
  String get policyFlexibleDesc =>
      'Reembolso completo si el cliente cancela hasta 24 horas antes del evento.';

  @override
  String get policyModerateDesc =>
      '50 % de reembolso si se cancela al menos 7 días antes del evento; ninguno después.';

  @override
  String get policyStrictDesc => 'Sin reembolso una vez confirmada la reserva.';

  @override
  String get asCategoryInfo =>
      'La categoría de servicio por la que navegan los clientes. Aquí solo aparecen las categorías que registraste en tu perfil.';

  @override
  String get asPriceRange => 'Rango de precios';

  @override
  String get asPriceRangeInfo =>
      'La franja de precios habitual de este servicio. Los clientes la ven como orientación; el importe final se acuerda en tu presupuesto.';

  @override
  String get asMin => 'Mín.';

  @override
  String get asMax => 'Máx.';

  @override
  String get asServiceDuration => 'Duración del servicio';

  @override
  String get durationDays => 'Días';

  @override
  String get durationHours => 'Horas';

  @override
  String get durationMins => 'Min';

  @override
  String get asDurationHint => 'Introduce el valor de la duración...';

  @override
  String get asSelectPolicy => 'Selecciona una política';

  @override
  String get asCancellationPolicyInfo =>
      'Cómo funcionan los reembolsos si un cliente cancela. Elige el nivel que mejor se adapte a tu negocio.';

  @override
  String get asTitle => 'Añadir un servicio';

  @override
  String get asSubtitle => 'Añade un servicio para tu negocio';

  @override
  String get asServiceName => 'Nombre del servicio';

  @override
  String get asServiceNameHint => 'Introduce el nombre del servicio...';

  @override
  String get asServiceNameInfo =>
      'Un nombre corto y claro que verán los clientes, p. ej. \"Fotografía de boda — día completo\".';

  @override
  String get asServiceDescription => 'Descripción del servicio';

  @override
  String get asServiceDescriptionHint => 'Describe tu servicio...';

  @override
  String get asServiceDescriptionInfo =>
      'Qué incluye, tu experiencia y lo que los clientes pueden esperar. Cuanto más detalle, más confianza.';

  @override
  String get asTagsHint => 'p. ej. Boda, Fotografía, Exterior';

  @override
  String get asServicePhotos => 'Fotos del servicio';

  @override
  String asPhotoNumber(int number) {
    return 'Foto $number';
  }

  @override
  String get asPublishService => 'Publicar servicio';

  @override
  String get loading => 'Cargando…';

  @override
  String get ldNotFound => 'Anuncio no encontrado';

  @override
  String get ldServiceLower => 'servicio';

  @override
  String get ldProductLower => 'producto';

  @override
  String ldDeleted(String noun) {
    return '$noun eliminado';
  }

  @override
  String ldDeactivated(String noun) {
    return '$noun desactivado';
  }

  @override
  String get ldEditService => 'Editar servicio';

  @override
  String get ldEditProduct => 'Editar producto';

  @override
  String get ldDeleteService => 'Eliminar servicio';

  @override
  String get ldDeleteProduct => 'Eliminar producto';

  @override
  String get ldDeactivateService => 'Desactivar servicio';

  @override
  String get ldDeactivateProduct => 'Desactivar producto';

  @override
  String get ldViews30d => 'Vistas (30 d)';

  @override
  String get ldRating => 'Valoración';

  @override
  String get ldNoReviews => 'Aún no hay reseñas';

  @override
  String get ldFixedPrice => 'Precio fijo';

  @override
  String get ldStartingFrom => 'Desde';

  @override
  String get ldQuoteOnRequest => 'Presupuesto a solicitud';

  @override
  String get ldType => 'Tipo';

  @override
  String get ldPricePerDay => 'Precio por día';

  @override
  String get ldStock => 'Stock';

  @override
  String get ldCancellationPolicy => 'Política de cancelación';

  @override
  String get ldPrice => 'Precio';

  @override
  String ldFrom(String price) {
    return 'Desde $price';
  }

  @override
  String get ldPricing => 'Precios';

  @override
  String get ldDuration => 'Duración';

  @override
  String ldInStock(int count) {
    return '$count en stock';
  }

  @override
  String get ldStatus => 'Estado';

  @override
  String get ldListed => 'Publicado';

  @override
  String ldDeleteTitle(String noun) {
    return 'Eliminar $noun';
  }

  @override
  String ldDeleteBody(String noun) {
    return '¿Seguro que quieres eliminar permanentemente este $noun?';
  }

  @override
  String get ldNevermind => 'Olvídalo';

  @override
  String get ldYesDelete => 'Sí, eliminar';

  @override
  String ldDeactivateTitle(String noun) {
    return 'Desactivar $noun';
  }

  @override
  String ldDeactivateBody(String noun) {
    return '¿Seguro que quieres desactivar temporalmente este $noun?';
  }

  @override
  String get ldDeactivationPeriod => 'Periodo de desactivación';

  @override
  String get ldSelectDuration => 'Selecciona la duración';

  @override
  String get ldSelectDurationTitle => 'Selecciona la duración';

  @override
  String get ld1Week => '1 semana';

  @override
  String get ld2Weeks => '2 semanas';

  @override
  String get ld1Month => '1 mes';

  @override
  String get ld3Months => '3 meses';

  @override
  String get ldYesDeactivate => 'Sí, desactivar';

  @override
  String get done => 'Listo';

  @override
  String elUpdateTitle(String label) {
    return 'Actualizar $label';
  }

  @override
  String get elServiceSubtitle => 'Actualiza este servicio para tu negocio';

  @override
  String get elProductSubtitle => 'Actualiza tu producto y aumenta tu stock';

  @override
  String get elPhotoComingSoon => 'La subida de fotos estará disponible pronto';

  @override
  String get elSelectSizes => 'Selecciona las tallas';

  @override
  String get elForSale => 'En venta';

  @override
  String get elForRent => 'En alquiler';

  @override
  String get elProductType => 'Tipo de producto 📦';

  @override
  String get elSelectType => 'Selecciona el tipo';

  @override
  String get elProductTypeSheet => 'Tipo de producto';

  @override
  String get elSizes => 'Tallas ';

  @override
  String get elOptional => '(opcional)';

  @override
  String get elSelectSizesPlaceholder => 'Selecciona las tallas';

  @override
  String get elRentalDuration => 'Duración del alquiler';

  @override
  String get elSkuHint => 'Introduce el SKU...';

  @override
  String get elMainPhoto => 'Foto principal';

  @override
  String get elSecondPhoto => 'Segunda foto';

  @override
  String get elThirdPhoto => 'Tercera foto';

  @override
  String get elFourthPhoto => 'Cuarta foto';

  @override
  String get elUpdatedSuccess => 'Anuncio actualizado correctamente';

  @override
  String get trackingTitle => 'Seguimiento de pedidos';

  @override
  String get trackingComingSoon =>
      'El seguimiento de pedidos estará disponible pronto';

  @override
  String get trackingComingSoonBody =>
      'El seguimiento de entregas y alquileres aparecerá aquí cuando esté disponible.';

  @override
  String get reviewClientFallback => 'Cliente';

  @override
  String get reviewTitle => 'Reseña';

  @override
  String reviewSubtitle(String name) {
    return 'Cuéntanos cómo fue tu experiencia con $name';
  }

  @override
  String get reviewFeedbackLabel => 'Deja un comentario detallado';

  @override
  String get reviewFeedbackHint => 'Cuéntanos cómo fue tu experiencia';

  @override
  String get reviewSubmitted => '¡Reseña enviada!';

  @override
  String get reviewSendReview => 'Enviar reseña';

  @override
  String get cancelBookingTitle => 'Cancelar reserva';

  @override
  String get coReason1 => 'El cliente fue grosero';

  @override
  String get coReason2 => 'El evento fue más de lo descrito';

  @override
  String get coReason3 => 'El cliente llegó tarde al evento';

  @override
  String get coReason4 => 'El cliente se negó a pagar el segundo plazo';

  @override
  String get coReason5 => 'Otro problema';

  @override
  String get coNotice =>
      'Nuestro equipo media en todas las disputas. Buscamos resolverlas en 48 horas. Prueba a escribir primero al cliente: la mayoría de los problemas se resuelven rápido.';

  @override
  String get coReasonTitle => 'Motivo de la cancelación de la reserva';

  @override
  String get coDescribeIssue => 'Describe el problema';

  @override
  String get coDescribeHint =>
      'Describe con detalle lo que ocurrió, incluye fechas, importes y cualquier contexto relevante';

  @override
  String get coAttachEvidence => 'Adjuntar pruebas (opcional)';

  @override
  String get coUploadImage => 'Subir imagen';

  @override
  String get coBookingCancelled => 'Reserva cancelada';

  @override
  String get coCancelOrder => 'Cancelar pedido';

  @override
  String get coMessageClient => 'Mejor mensajear al cliente';

  @override
  String get msgTitle => 'Mensajes';

  @override
  String get msgSubtitle => 'Mantente en contacto con tus clientes';

  @override
  String get msgSearchHint => 'Buscar conversaciones';

  @override
  String get msgNoConversations => 'No se encontraron conversaciones';

  @override
  String msgParticipants(int count) {
    return '$count participantes';
  }

  @override
  String get convConfirmed => 'Confirmado';

  @override
  String get convDeclined => 'Rechazado';

  @override
  String get convQuoteExpired => 'Presupuesto vencido';

  @override
  String convDepositRefundedAmt(String amount) {
    return 'Depósito reembolsado · \$$amount';
  }

  @override
  String get convDepositRefunded => 'Depósito reembolsado';

  @override
  String convPaymentReceivedAmt(String amount) {
    return 'Pago recibido · \$$amount';
  }

  @override
  String get convPaymentReceived => 'Pago recibido';

  @override
  String get convOrderUpdate => 'Actualización del pedido';

  @override
  String get convReviewRequested => 'Reseña solicitada';

  @override
  String convReviewLeftRating(String rating) {
    return 'El cliente dejó una reseña · $rating★';
  }

  @override
  String get convReviewLeft => 'El cliente dejó una reseña';

  @override
  String get convBankBanner =>
      'Presupuesto aceptado: añade tu cuenta bancaria para cobrar.';

  @override
  String get convAdd => 'Añadir';

  @override
  String get convConfirmReturn => 'Confirmar devolución';

  @override
  String get convMarkDelivered => 'Marcar como entregado';

  @override
  String get convPostUpdate => 'Publicar actualización';

  @override
  String get convConfirmReturnTitle => '¿Confirmar la devolución del alquiler?';

  @override
  String get convConfirmReturnBody =>
      'Esto completa el alquiler y reembolsa el depósito del cliente. Devuelve el depósito al cliente desde tu banco.';

  @override
  String get convRentalCompleted =>
      'Alquiler completado: depósito reembolsado 🎉';

  @override
  String get convPostUpdateTitle => 'Publicar una actualización';

  @override
  String get convPostUpdateHint =>
      'p. ej. En reparto: llega antes de las 16:00';

  @override
  String get convPost => 'Publicar';

  @override
  String get convUpdatePosted => 'Actualización publicada';

  @override
  String get convMarkDeliveredTitle => '¿Marcar como entregado?';

  @override
  String get convMarkDeliveredBody =>
      'Esto completa la reserva y pide al cliente que deje una reseña.';

  @override
  String get convMarkedDelivered => 'Marcado como entregado 🎉';

  @override
  String get convReviseQuote => 'Revisar presupuesto';

  @override
  String get convCreateSendQuote => 'Crear y enviar presupuesto';

  @override
  String get convOrderAccepted => 'Pedido aceptado: factura enviada 🎉';

  @override
  String get convOrderDeclined => 'Pedido rechazado';

  @override
  String get convCouldNotIdentifyClient => 'No se pudo identificar al cliente';

  @override
  String get convCouldNotUpdateTask => 'No se pudo actualizar la tarea';

  @override
  String get convCouldNotLoadListings => 'No se pudieron cargar tus anuncios';

  @override
  String get convAddListingFirst =>
      'Añade primero un anuncio para enviar un presupuesto';

  @override
  String get convQuoteForListing => '¿Presupuesto para qué anuncio?';

  @override
  String get convTypeMessage => 'Escribe un mensaje';

  @override
  String get cqAddLineItem => 'Añade al menos una línea con un importe';

  @override
  String get cqRevisedSent => 'Presupuesto revisado enviado 🎉';

  @override
  String get cqQuoteSent => 'Presupuesto enviado al cliente 🎉';

  @override
  String get cqOpenFromChat =>
      'Abre esto desde un chat o consulta de cliente para enviar un presupuesto';

  @override
  String get cqValidForTitle => 'Presupuesto válido durante';

  @override
  String get cqTitleCreate => 'Crear presupuesto';

  @override
  String get cqEvent => 'Evento';

  @override
  String get cqDescription => 'Descripción';

  @override
  String get cqAmount => 'Importe';

  @override
  String get cqAddItem => '+ Añadir elemento';

  @override
  String cqSubtotal(String amount) {
    return 'Subtotal $amount';
  }

  @override
  String cqMilestone(int number) {
    return 'Hito $number';
  }

  @override
  String get cqLineItems => 'Líneas';

  @override
  String get cqSetPaymentTerms => 'Condiciones de pago (opcional)';

  @override
  String get cqPaymentTermsHint =>
      'p. ej. 50 % de depósito, resto a la entrega — pagado directamente';

  @override
  String get cqNoteToClient => 'Nota para el cliente';

  @override
  String get cqNoteHint => 'Breve descripción del producto';

  @override
  String get cqSending => 'Enviando…';

  @override
  String get cqSendRevised => 'Enviar presupuesto revisado';

  @override
  String get cqCreateQuote => 'Crear presupuesto';

  @override
  String get cqDueOnConfirmation =>
      'A pagar al confirmar la reserva (de inmediato)';

  @override
  String get cqTermPayAtOnce => 'Pagar de una vez';

  @override
  String get cqTermCustom => 'Personalizado';

  @override
  String get cqValid1Day => '1 día';

  @override
  String get cqValid3Days => '3 días';

  @override
  String get cqValid7Days => '7 días';

  @override
  String get cqValid14Days => '14 días';

  @override
  String get cqValid30Days => '30 días';

  @override
  String get ciTitle => 'Crear factura';

  @override
  String get ciInvoiceItems => 'Elementos de la factura';

  @override
  String get ciPaymentMilestones => 'Hitos de pago';

  @override
  String get ciFromQuote => 'Desde el presupuesto';

  @override
  String get ciBanner =>
      'Rellenado a partir del presupuesto aceptado QT-2026-047. Revisa los elementos y los hitos de pago, luego envía para confirmar la reserva.';

  @override
  String get ciPayoutToAccount => 'Pago a tu cuenta';

  @override
  String get ciAccount => 'Cuenta';

  @override
  String get ciYourPayout => 'Tu pago';

  @override
  String ciSendInvoiceTo(String name) {
    return 'Enviar factura a $name';
  }

  @override
  String get ciInvoiceSent => '¡Factura enviada correctamente!';

  @override
  String get ciPreview => 'Vista previa';

  @override
  String get profileYourBusiness => 'Tu negocio';

  @override
  String profilePlanLabel(String tier) {
    return 'Plan $tier';
  }

  @override
  String get profileVerified => 'Verificado';

  @override
  String get profileUnverified => 'Sin verificar';

  @override
  String get profileGeneral => 'General';

  @override
  String get profilePreferences => 'Preferencias';

  @override
  String get profileUpdateProfile => 'Actualiza tu perfil';

  @override
  String get profileSecurity => 'Seguridad';

  @override
  String get profileReviews => 'Reseñas';

  @override
  String get profileLinkedBanks => 'Cuentas bancarias vinculadas';

  @override
  String get profileGallery => 'Galería';

  @override
  String get profileSubscriptionPlans => 'Planes de suscripción';

  @override
  String get profileLanguagePref => 'Preferencia de idioma';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileCustomizeStorefront => 'Personaliza tu escaparate';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profileHelpSupport => 'Ayuda y soporte';

  @override
  String get profileTerms => 'Términos y condiciones';

  @override
  String get profileLeavePlanovar => 'Abandonar Planovar';

  @override
  String get profileSignOut => 'Cerrar sesión';

  @override
  String psUploadLogoFailed(String error) {
    return 'No se pudo subir el logotipo: $error';
  }

  @override
  String psUploadCoverFailed(String error) {
    return 'No se pudo subir la portada: $error';
  }

  @override
  String get psProfileUpdated => 'Perfil actualizado';

  @override
  String get psEmailAddress => 'Correo electrónico';

  @override
  String get psEmailHint => 'Correo electrónico';

  @override
  String get psPhoneNumber => 'Número de teléfono';

  @override
  String get psPhoneHint => 'Número de teléfono';

  @override
  String get psDateOfBirth => 'Fecha de nacimiento';

  @override
  String get psUpdateDetails => 'Actualizar datos';

  @override
  String get psAddCoverPhoto => 'Añadir foto de portada';

  @override
  String get psStorefrontHint =>
      'Tu logotipo y tu portada son lo que ven los clientes en tu escaparate.';

  @override
  String get psStorefrontImages => 'Imágenes del escaparate';

  @override
  String get psBusinessName => 'Nombre del negocio';

  @override
  String get psBusinessNameHint => 'Nombre del negocio';

  @override
  String get psBusinessType => 'Tipo de negocio';

  @override
  String get psBizLicensed => 'Negocio registrado';

  @override
  String get psBizFreelancer => 'Autónomo';

  @override
  String get psBusinessDescription => 'Descripción del negocio';

  @override
  String get psBusinessDescHint => 'Breve descripción de tu negocio';

  @override
  String get psCategoryTags => 'Etiquetas de categoría';

  @override
  String get psEditProfile => 'Edita tu perfil';

  @override
  String get psPersonalDetails => 'Datos personales';

  @override
  String get psBusinessDetails => 'Datos del negocio';

  @override
  String get psMonthJan => 'Enero';

  @override
  String get psMonthFeb => 'Febrero';

  @override
  String get psMonthMar => 'Marzo';

  @override
  String get psMonthApr => 'Abril';

  @override
  String get psMonthMay => 'Mayo';

  @override
  String get psMonthJun => 'Junio';

  @override
  String get psMonthJul => 'Julio';

  @override
  String get psMonthAug => 'Agosto';

  @override
  String get psMonthSep => 'Septiembre';

  @override
  String get psMonthOct => 'Octubre';

  @override
  String get psMonthNov => 'Noviembre';

  @override
  String get psMonthDec => 'Diciembre';

  @override
  String get psSecurity => 'Seguridad';

  @override
  String get psChangePassword => 'Cambiar contraseña';

  @override
  String get psChangePasswordSub => 'Actualiza tu contraseña de acceso.';

  @override
  String get ps2faTitle => 'Autenticación 2FA';

  @override
  String get ps2faSub => 'Añade una capa extra de seguridad.';

  @override
  String get psNewPassword => 'Nueva contraseña';

  @override
  String get psNewPasswordHint => 'Introduce la nueva contraseña';

  @override
  String get psConfirmPassword => 'Confirmar contraseña';

  @override
  String get psConfirmPasswordHint => 'Confirma la nueva contraseña';

  @override
  String get psReqCapital => 'Debe tener una letra mayúscula';

  @override
  String get psReqNumber => 'Debe tener un número, p. ej. 1, 2, 4, etc.';

  @override
  String get psReqSpecial =>
      'Debe tener un carácter especial, p. ej. @, \$, %, etc.';

  @override
  String get psSavePassword => 'Guardar contraseña';

  @override
  String get psPasswordSaved => 'Contraseña guardada';

  @override
  String get psTheme => 'Tema';

  @override
  String get psSelectDisplay => 'Selecciona tu visualización preferida';

  @override
  String get psThemeLight => 'Claro';

  @override
  String get psThemeDark => 'Oscuro';

  @override
  String get psThemeSystem => 'Sistema';

  @override
  String get psSavePreference => 'Guardar preferencia';

  @override
  String get psThemeSaved => 'Preferencia de tema guardada';

  @override
  String get psNotification => 'Notificación';

  @override
  String get psChannelNone => 'Ninguno';

  @override
  String get psChannelInApp => 'En la app';

  @override
  String get psChannelEmail => 'Correo electrónico';

  @override
  String get psChannelBoth => 'Ambos';

  @override
  String get psAllNotifications => 'Todas las notificaciones';

  @override
  String get psChooseWhere => 'Elige dónde quieres recibir notificaciones';

  @override
  String get psNotifAllMessages => 'Todos los mensajes';

  @override
  String get psNotifAllMessagesSub => 'alguien responde a tu mensaje';

  @override
  String get psNotifOrderDelivery => 'Cronograma de pedido/entrega';

  @override
  String get psNotifOrderDeliverySub =>
      'recibe una notificación cuando se recibe/completa un pedido';

  @override
  String get psNotifEventTimeline => 'Cronograma del evento';

  @override
  String get psNotifEventTimelineSub =>
      'recibe una notificación cuando hay un nuevo cronograma de evento';

  @override
  String get psNotifPayment => 'Alertas de pago';

  @override
  String get psNotifPaymentSub =>
      'recibe una notificación cuando un pago se realiza con éxito';

  @override
  String get psNotifQuoteInvoice => 'Alertas de presupuesto/factura';

  @override
  String get psNotifQuoteInvoiceSub =>
      'recibe una notificación cuando actúan sobre tu presupuesto';

  @override
  String get psLinkedBankAccount => 'Cuenta bancaria vinculada';

  @override
  String get psWhereClientsPay => 'Donde los clientes te pagan directamente';

  @override
  String get psAddBankAccount => 'Añadir cuenta bancaria';

  @override
  String get psChangeBankAccount => 'Cambiar cuenta bancaria';

  @override
  String get psNoBankYet => 'Aún no hay cuenta bancaria';

  @override
  String get psNoBankBody =>
      'Añade una para que los clientes puedan pagarte directamente cuando acepten tus presupuestos.';

  @override
  String get psBankFallback => 'Banco';

  @override
  String get psReadyToReceive => 'Listo para recibir pagos';

  @override
  String get psSettingUp => 'Configurando…';

  @override
  String get psReasonNoNeed => 'Ya no necesito el servicio';

  @override
  String get psReasonBetter => 'Encontré una plataforma mejor';

  @override
  String get psReasonTech => 'Demasiados problemas técnicos';

  @override
  String get psReasonPrivacy => 'Preocupaciones de privacidad';

  @override
  String get psReasonOther => 'Otro';

  @override
  String get psSelectReason => 'Selecciona un motivo';

  @override
  String get psDeleteConfirmTitle => '¿Seguro que quieres eliminar?';

  @override
  String get psDeleteBullet1 => 'Acceso a tus reservas activas';

  @override
  String get psDeleteBullet2 =>
      'Acceso a los registros y credenciales de tu cuenta';

  @override
  String get psDeleteBullet3 => 'Datos de acceso';

  @override
  String get psDeleteBullet4 =>
      'Todos los contactos de clientes por mensaje y llamada';

  @override
  String get psYesConfirm => 'Sí, confirmar';

  @override
  String get psNotYet => 'Todavía no';

  @override
  String get psSuccessful => 'Correcto';

  @override
  String get psDeleteSuccessBody =>
      'Tu cuenta se ha eliminado correctamente. Lamentamos que te vayas y esperamos verte pronto';

  @override
  String get psCloseApp => 'Cerrar la app';

  @override
  String get psDeleteAccount => 'Eliminar cuenta';

  @override
  String get psYourAccount => 'Tu cuenta';

  @override
  String get psTellReason => 'Cuéntanos el motivo para eliminar tu cuenta';

  @override
  String get psSelectOption => 'Selecciona una opción';

  @override
  String get psOtherReasons => 'Otros motivos';

  @override
  String get psTypeMessage => 'Escribe tu mensaje';

  @override
  String get psDeactivateAccount => 'Desactivar cuenta';

  @override
  String get psAccountDeactivated => 'Cuenta desactivada';

  @override
  String psTrialStarted(String name) {
    return 'Tu prueba gratuita de $name ha comenzado 🎉';
  }

  @override
  String psNowOnPlan(String name) {
    return 'Ahora tienes el plan $name';
  }

  @override
  String get psPaymentCancelled => 'Pago cancelado: tu plan no ha cambiado';

  @override
  String psPaymentConfirmed(String name) {
    return 'Pago confirmado: ahora tienes el plan $name';
  }

  @override
  String get psSubscriptionPlan => 'Plan de suscripción';

  @override
  String get psChoosePlan =>
      'Elige el plan que se adapta a tu negocio. Mejora o cambia cuando quieras.';

  @override
  String get psOnTrial => 'En prueba';

  @override
  String get psCurrent => 'Actual';

  @override
  String psSwitchTo(String name) {
    return 'Cambiar a $name';
  }

  @override
  String psUpgradeTo(String name) {
    return 'Mejorar a $name';
  }

  @override
  String reviewsReplyTo(String name) {
    return 'Responder a $name';
  }

  @override
  String get reviewsReplyHint => 'Agradéceles o responde a sus comentarios…';

  @override
  String get reviewsSending => 'Enviando…';

  @override
  String get reviewsSendReply => 'Enviar respuesta';

  @override
  String get reviewsMyReviews => 'Mis reseñas';

  @override
  String get reviewsSubtitle =>
      'Reseñas que has recibido de tus trabajos anteriores';

  @override
  String get reviewsLoadFailed => 'No se pudieron cargar las reseñas';

  @override
  String get reviewsEmpty => 'Aún no hay reseñas';

  @override
  String get reviewsEmptyBody =>
      'Completa reservas y las reseñas de tus clientes aparecerán aquí.';

  @override
  String reviewsCount(int total) {
    return '($total reseñas)';
  }

  @override
  String reviewsMonthsAgo(int count) {
    return 'hace $count meses';
  }

  @override
  String reviewsDaysAgo(int count) {
    return 'hace $count días';
  }

  @override
  String reviewsHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String get reviewsJustNow => 'ahora mismo';

  @override
  String get reviewsReply => 'Responder';

  @override
  String get reviewsYourReply => 'Tu respuesta';

  @override
  String get termsRowTitle => 'Términos y condiciones';

  @override
  String get termsLastUpdated => 'Última actualización: 17 de abril de 2025';

  @override
  String get termsPrivacyPolicy => 'Política de privacidad';

  @override
  String get termsPrivacySubtitle => 'Lee nuestro acuerdo de privacidad';

  @override
  String get termsOfUse => 'Condiciones de uso';

  @override
  String get galleryPhoto1 => 'Foto frontal';

  @override
  String get galleryPhoto2 => 'Segunda foto';

  @override
  String get galleryPhoto3 => 'Tercera foto';

  @override
  String get galleryPhoto4 => 'Cuarta foto';

  @override
  String galleryUploadFailed(String error) {
    return 'No se pudo subir la foto: $error';
  }

  @override
  String get gallerySaved => 'Galería guardada';

  @override
  String gallerySaveFailed(String error) {
    return 'No se pudo guardar la galería: $error';
  }

  @override
  String get gallerySubtitle =>
      'Muestra tus mejores trabajos para atraer clientes';

  @override
  String get gallerySaveButton => 'Guardar galería';

  @override
  String get supportTitle => 'Soporte';

  @override
  String supportGreeting(String name) {
    return 'Hola, $name 👋';
  }

  @override
  String get supportThere => 'amigo';

  @override
  String get supportSearchHint => '¿Cómo podemos ayudarte?';

  @override
  String get supportPromoTitle => 'Sistema de soporte de primera';

  @override
  String get supportPromoSub =>
      'Obtén respuestas rápidas con nuestro chat en línea';

  @override
  String get supportFaqTitle => 'Preguntas frecuentes';

  @override
  String get supportViewMore => 'Ver más preguntas';

  @override
  String get supportChat => 'Chat';

  @override
  String get supportChatSub => '¿Necesitas ayuda? Estamos aquí para ti';

  @override
  String get supportCallSupport => 'Llamar a soporte';

  @override
  String get supportCallHours =>
      'Disponible de lunes a viernes, de 9:00 a 17:00';

  @override
  String get supportFaqQ1 => '¿Cómo creo un anuncio?';

  @override
  String get supportFaqQ2 => '¿Cómo gestiono las reservas?';

  @override
  String get supportFaqQ3 => '¿Cómo pagan los clientes mis servicios?';

  @override
  String get supportFaqQ4 => '¿Cómo retiro mis ganancias?';

  @override
  String get supportFaqQ5 => '¿Qué comisiones cobra Planovar?';

  @override
  String get supportFaqQ6 => '¿Cómo verifico mi cuenta?';

  @override
  String get supportFaqQ7 => '¿Puedo cancelar una reserva?';

  @override
  String get supportFaqQ8 => '¿Cómo funcionan las reseñas?';

  @override
  String get supportFaqQ9 => '¿Cómo mejoro mi suscripción?';

  @override
  String get supportFaqQ10 => '¿Cómo contacto con un cliente?';

  @override
  String supportQuestionN(int number) {
    return 'Pregunta $number';
  }

  @override
  String get supportNeedMoreHelp => 'Necesito más ayuda';

  @override
  String get supportChatWithUs => 'Chatea con nosotros';

  @override
  String get supportCallUs => 'Llámanos';

  @override
  String get supportCallAvailable =>
      'Estamos disponibles de lunes a viernes de 9:00 a 17:00';

  @override
  String get supportLiveSupport => 'Soporte en vivo';

  @override
  String get supportReplyMinutes => 'Normalmente respondemos en unos minutos';

  @override
  String get supportChatSetup => 'El chat en vivo se está configurando';

  @override
  String get supportChatSetupMsg =>
      'Nuestro chat en vivo aún no está conectado. Mientras tanto, escríbenos por correo y te responderemos enseguida.';

  @override
  String get supportEmailSupport => 'Soporte por correo';

  @override
  String get supportChatTeam => 'Chatea con nuestro equipo';

  @override
  String get supportChatTeamMsg =>
      'Abre nuestro chat en vivo para hablar con un agente de soporte.';

  @override
  String get supportOpenChat => 'Abrir chat en vivo';

  @override
  String get twofaIntroTitle => 'Activa 2FA para mayor seguridad';

  @override
  String get twofaGetStarted => 'Empezar';

  @override
  String get twofaSetupTitle => 'Configuración de 2FA';

  @override
  String get twofaSetUpUsing => 'Configurar con';

  @override
  String get twofaAuthenticatorHint =>
      'Usando la app de autenticación como (Google Authenticator, Authy, 1Password, LastPass, etc.)';

  @override
  String get twofaScanMe => 'Escanéame';

  @override
  String get twofaCantScan =>
      'Si no puedes escanear el código QR de arriba, introduce este texto en su lugar';

  @override
  String get twofaConfirmCode => 'Confirmar código';

  @override
  String get twofaEnterCode =>
      'Introduce el código proporcionado por la app de autenticación';

  @override
  String get twofaConfirm => 'Confirmar';

  @override
  String get twofaAllPrefix => 'Todo ';

  @override
  String get twofaDoneWord => 'listo';

  @override
  String get twofaSuccessBody => 'Tu 2FA se ha activado correctamente';

  @override
  String get twofaBackToProfile => 'Volver a la configuración del perfil';

  @override
  String get analyticsTitle => 'Analíticas';

  @override
  String get analyticsActiveListings => 'Anuncios activos';

  @override
  String analyticsOfTotal(int total) {
    return 'de $total en total';
  }

  @override
  String get analyticsInquiries => 'Consultas';

  @override
  String analyticsAwaitingReply(int count) {
    return '$count esperando respuesta';
  }

  @override
  String get analyticsRating => 'Valoración';

  @override
  String analyticsReviews(int count) {
    return '$count reseñas';
  }

  @override
  String get analyticsPlan => 'Plan';

  @override
  String get analyticsDetailedTitle => 'Analíticas de rendimiento detalladas';

  @override
  String get analyticsComingSoon =>
      'Las tendencias, las vistas de perfil y los gráficos de conversión estarán disponibles pronto.';

  @override
  String get payoutsTitle => 'Pagos';

  @override
  String get payoutsHeadline => 'Te quedas con el 100 % de lo que ganas';

  @override
  String get payoutsBody =>
      'Planovar funciona con una suscripción: no retenemos tu dinero ni cobramos comisión. Los clientes te pagan directamente, como acordéis.';

  @override
  String get notifMarkAllRead => 'Marcar todo como leído';

  @override
  String get notifEmpty => 'No hay notificaciones';

  @override
  String get notifFilterAll => 'Todas';

  @override
  String get notifFilterOrders => 'Pedidos';

  @override
  String get notifFilterPayments => 'Pagos';

  @override
  String get notifFilterSystem => 'Sistema';

  @override
  String get notifToday => 'Hoy';

  @override
  String get notifYesterday => 'Ayer';

  @override
  String get notifEarlier => 'Anteriores';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusConfirmed => 'Confirmado';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get statusSent => 'Enviado';

  @override
  String get statusAccepted => 'Aceptado';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String get statusDeclined => 'Denegado';

  @override
  String get statusPaid => 'Pagado';

  @override
  String get statusFailed => 'Fallido';

  @override
  String get statusFeatured => 'Destacado';

  @override
  String get statusPremium => 'Premium';

  @override
  String get statusBasic => 'Básico';

  @override
  String get statusExpired => 'Vencido';

  @override
  String get statusSuperseded => 'Reemplazado';

  @override
  String get statusPartiallyPaid => 'Pagado parcialmente';

  @override
  String get ccQuote => 'Presupuesto';

  @override
  String ccValidTill(String date) {
    return 'Válido hasta $date';
  }

  @override
  String get ccTotal => 'Total';

  @override
  String ccInvoiceNumber(String number) {
    return 'Factura · $number';
  }

  @override
  String get ccOrderRequest => 'Solicitud de pedido';

  @override
  String get ccClientRequesting =>
      'El cliente está solicitando esto: acepta para enviar una factura';

  @override
  String get ccDecline => 'Rechazar';

  @override
  String get ccAccept => 'Aceptar';

  @override
  String ccDue(String date) {
    return 'Vence $date';
  }

  @override
  String get ccTaskDone => 'Has completado tu tarea';

  @override
  String get ccMarkTaskDone => 'Marca tu tarea como hecha';

  @override
  String get errorSomethingWrong => 'Algo salió mal';

  @override
  String get errorTryAgain => 'Inténtalo de nuevo';

  @override
  String get bankAdded => 'Cuenta bancaria añadida: ya puedes recibir pagos 🎉';

  @override
  String get bankClientsPayDirect =>
      'Los clientes te pagan directamente a esta cuenta.';

  @override
  String get bankLoading => 'Cargando bancos…';

  @override
  String get bankSelect => 'Selecciona el banco';

  @override
  String get bankAccountNumberHint => 'Número de cuenta de 10 dígitos';

  @override
  String get bankVerifying => 'Verificando la cuenta…';

  @override
  String get bankSaving => 'Guardando…';

  @override
  String get bankSaveAccount => 'Guardar cuenta';

  @override
  String get bankSearch => 'Buscar banco';

  @override
  String get planPopular => 'POPULAR';

  @override
  String get planCurrentPlan => 'Plan actual';

  @override
  String get planMonthly => 'Mensual';

  @override
  String get planYearly => 'Anual';

  @override
  String get qrcNew => 'Nuevo';

  @override
  String qrcBudget(String amount) {
    return 'Presupuesto: $amount';
  }

  @override
  String get qrcBudgetTbd => 'Presupuesto: por definir';

  @override
  String get qrcOpenRespond => 'Abrir y responder';

  @override
  String get qrcReject => 'Rechazar';

  @override
  String get tagAddMore => 'Añadir etiqueta...';

  @override
  String tagHelper(int count, int max) {
    return 'Pulsa coma o Intro para añadir una etiqueta  ·  $count/$max';
  }

  @override
  String get psCurrentPassword => 'Contraseña actual';

  @override
  String get psCurrentPasswordHint => 'Introduce tu contraseña actual';

  @override
  String get psCurrentPasswordRequired => 'Introduce tu contraseña actual';

  @override
  String get psPasswordTooWeak =>
      'Tu nueva contraseña debe tener al menos 8 caracteres e incluir una letra mayúscula, un número y un carácter especial';

  @override
  String get psPasswordsDontMatch => 'Las nuevas contraseñas no coinciden';

  @override
  String get tfaChallengeTitle => 'Autenticación de dos factores';

  @override
  String get tfaChallengeSubtitle =>
      'Introduce el código de 6 dígitos de tu app de autenticación';

  @override
  String get tfaVerify => 'Verificar';

  @override
  String get twofaDisable => 'Desactivar la doble autenticación';

  @override
  String get twofaConfirmPasswordTitle => 'Confirma tu contraseña';

  @override
  String get twofaContinue => 'Continuar';

  @override
  String get twofaDisabled => 'Autenticación de dos factores desactivada';

  @override
  String get twofaSecretCopied => 'Clave de configuración copiada';

  @override
  String get twofaBackupCodesTitle => 'Códigos de respaldo';

  @override
  String get twofaBackupCodesHint =>
      'Guárdalos en un lugar seguro: cada uno puede usarse una vez si pierdes tu autenticador.';

  @override
  String get cqAfterEvent => 'Después del evento';
}
