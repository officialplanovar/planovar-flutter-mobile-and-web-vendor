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
  String get settings => 'Paramètres';

  @override
  String get home => 'Accueil';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Se déconnecter';
}
