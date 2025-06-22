// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get appTitle => 'Markdown Editor';

  @override
  String get previewToolTip => 'Preview';

  @override
  String get switchThemeMenuItem => 'Switch Theme';

  @override
  String get switchViewMenuItem => 'Switch View';

  @override
  String get openFileMenuItem => 'Open';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'Enter your markdown text here';

  @override
  String get storagePermission => 'Storage Permission';

  @override
  String get storagePermissionContent =>
      'Please allow external storage permissions on the next screen to be able to open, edit and save markdown files';

  @override
  String get error => 'Error';

  @override
  String get unableToOpenFileError =>
      'Unable to open the file, try opening it from open file option on the menu';

  @override
  String get unableToOpenFileFromMenuError => 'Unable to open the file';

  @override
  String get emptyInputTextContent => 'Please enter some text';

  @override
  String get clear => 'Clear';

  @override
  String get clearAllTitle => 'Clear All';

  @override
  String get clearAllContent =>
      'Are you sure do you want to clear all the text?';

  @override
  String get saveFileDialogTitle => 'Enter the name of the file';

  @override
  String get saveFileDialogHintText => 'FileName';

  @override
  String get save => 'Save';

  @override
  String fileSaveSuccess(String filePath) {
    return 'File Saved successfully at $filePath';
  }

  @override
  String get fileSaveError =>
      'Error Saving the file, Try Granting File Access Permission in the settings';

  @override
  String get imageAlternateTextFallback => 'Unable to Display the Image';

  @override
  String get example => 'example';

  @override
  String get linkDialogTextTitle => 'Text';

  @override
  String get linkDialogLinkTitle => 'Link';

  @override
  String get enterLinkTextDialogTitle => 'Enter Link';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get link => 'Link';

  @override
  String get image => 'Image';

  @override
  String get heading => 'Heading';

  @override
  String get code => 'Code';

  @override
  String get bulletList => 'Bullet List';

  @override
  String get quote => 'Quote';

  @override
  String get horizontalRule => 'Horizontal Rule';

  @override
  String get strikethrough => 'Strikethrough';
}
