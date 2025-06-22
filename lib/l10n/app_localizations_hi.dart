// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get ok => 'ठीक है';

  @override
  String get yes => 'हाँ';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get appTitle => 'मार्कडाउन संपादक';

  @override
  String get previewToolTip => 'पूर्वावलोकन';

  @override
  String get switchThemeMenuItem => 'थीम बदलें';

  @override
  String get switchViewMenuItem => 'दृश्य बदलें';

  @override
  String get openFileMenuItem => 'खोलें';

  @override
  String get defaultFileName => 'मार्कडाउन';

  @override
  String get markdownTextInputLabel => 'अपना मार्कडाउन टेक्स्ट यहाँ दर्ज करें';

  @override
  String get storagePermission => 'संग्रहण अनुमति';

  @override
  String get storagePermissionContent =>
      'कृपया अगली स्क्रीन पर बाहरी संग्रहण अनुमति दें ताकि मार्कडाउन फ़ाइलें खोलें, संपादित करें और सहेज सकें';

  @override
  String get error => 'त्रुटि';

  @override
  String get unableToOpenFileError =>
      'फ़ाइल नहीं खोल सकते, मेनू में खुली फ़ाइल विकल्प से खोलने का प्रयास करें';

  @override
  String get unableToOpenFileFromMenuError => 'फ़ाइल नहीं खोल सकता';

  @override
  String get emptyInputTextContent => 'कृपया कुछ टेक्स्ट दर्ज करें';

  @override
  String get clear => 'साफ';

  @override
  String get clearAllTitle => 'सब साफ करें';

  @override
  String get clearAllContent => 'क्या आप सभी पाठ को साफ करना चाहते हैं?';

  @override
  String get saveFileDialogTitle => 'फ़ाइल का नाम दर्ज करें';

  @override
  String get saveFileDialogHintText => 'फ़ाइल का नाम';

  @override
  String get save => 'सहेजें';

  @override
  String fileSaveSuccess(String filePath) {
    return 'फ़ाइल सफलतापूर्वक $filePath में सहेजी गई';
  }

  @override
  String get fileSaveError =>
      'त्रुटि फ़ाइल सहेजते समय, सेटिंग में फ़ाइल एक्सेस अनुमति प्रदान करने का प्रयास करें';

  @override
  String get imageAlternateTextFallback => 'चित्र नहीं दिखा सकता';

  @override
  String get example => 'उदाहरण';

  @override
  String get linkDialogTextTitle => 'टेक्स्ट';

  @override
  String get linkDialogLinkTitle => 'लिंक';

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
