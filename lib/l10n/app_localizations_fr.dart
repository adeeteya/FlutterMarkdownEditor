// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ok => 'D\'accord';

  @override
  String get yes => 'Oui';

  @override
  String get cancel => 'Annuler';

  @override
  String get appTitle => 'Éditeur Markdown';

  @override
  String get previewToolTip => 'Aperçu';

  @override
  String get switchThemeMenuItem => 'Changer de thème';

  @override
  String get switchViewMenuItem => 'Changer de vue';

  @override
  String get openFileMenuItem => 'Ouvrir';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'Entrez votre texte Markdown ici';

  @override
  String get storagePermission => 'Autorisation de stockage';

  @override
  String get storagePermissionContent =>
      'Veuillez autoriser les permissions de stockage externe à l\'écran suivant pour pouvoir ouvrir, éditer et enregistrer des fichiers Markdown.';

  @override
  String get error => 'Erreur';

  @override
  String get unableToOpenFileError =>
      'Impossible d\'ouvrir le fichier, essayez de l\'ouvrir à partir de l\'option de fichier ouvert dans le menu.';

  @override
  String get unableToOpenFileFromMenuError => 'Impossible d\'ouvrir le fichier';

  @override
  String get emptyInputTextContent => 'Veuillez saisir du texte';

  @override
  String get clear => 'Effacer';

  @override
  String get clearAllTitle => 'Tout effacer';

  @override
  String get clearAllContent =>
      'Êtes-vous sûr de vouloir effacer tout le texte ?';

  @override
  String get saveFileDialogTitle => 'Entrez le nom du fichier';

  @override
  String get saveFileDialogHintText => 'Nom du fichier';

  @override
  String get save => 'Enregistrer';

  @override
  String fileSaveSuccess(String filePath) {
    return 'Fichier enregistré avec succès à $filePath';
  }

  @override
  String get fileSaveError =>
      'Erreur lors de l\'enregistrement du fichier, essayez d\'accorder l\'autorisation d\'accès au fichier dans les paramètres.';

  @override
  String get imageAlternateTextFallback => 'Impossible d\'afficher l\'image.';

  @override
  String get example => 'exemple';

  @override
  String get linkDialogTextTitle => 'Texte';

  @override
  String get linkDialogLinkTitle => 'Lien';
}
