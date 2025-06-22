import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// Positive Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Alternate Positive Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative Action for the Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// The Name of the app
  ///
  /// In en, this message translates to:
  /// **'Markdown Editor'**
  String get appTitle;

  /// Tooltip for the Preview Icon Button
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewToolTip;

  /// Menu Item of Switch Theme
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchThemeMenuItem;

  /// Menu Item of Switch View
  ///
  /// In en, this message translates to:
  /// **'Switch View'**
  String get switchViewMenuItem;

  /// Menu Item of Open File
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openFileMenuItem;

  /// Default File Name of a new Markdown File
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get defaultFileName;

  /// InputText Label for the MarkDownTextInput Widget
  ///
  /// In en, this message translates to:
  /// **'Enter your markdown text here'**
  String get markdownTextInputLabel;

  /// Title for the Storage Permission Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Storage Permission'**
  String get storagePermission;

  /// Content for the Storage Permission Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Please allow external storage permissions on the next screen to be able to open, edit and save markdown files'**
  String get storagePermissionContent;

  /// Title for the Error Alert Dialog
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Content for the Error Alert Dialog when the file can't be opened
  ///
  /// In en, this message translates to:
  /// **'Unable to open the file, try opening it from open file option on the menu'**
  String get unableToOpenFileError;

  /// Content for the Error Alert Dialog when the file can't be opened from the menu
  ///
  /// In en, this message translates to:
  /// **'Unable to open the file'**
  String get unableToOpenFileFromMenuError;

  /// Content for the SnackBar when input text is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get emptyInputTextContent;

  /// Menu Item for Clearing Text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Title for the Clear All Dialog
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllTitle;

  /// Content for the Clear All Dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want to clear all the text?'**
  String get clearAllContent;

  /// Title for the Save File Dialog
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the file'**
  String get saveFileDialogTitle;

  /// Hint Text for the TextField of the Save File Dialog
  ///
  /// In en, this message translates to:
  /// **'FileName'**
  String get saveFileDialogHintText;

  /// Positive Action for the Save File Alert Dialog and the Save File Menu Item
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// File Save Success Message
  ///
  /// In en, this message translates to:
  /// **'File Saved successfully at {filePath}'**
  String fileSaveSuccess(String filePath);

  /// File Save Error Message
  ///
  /// In en, this message translates to:
  /// **'Error Saving the file, Try Granting File Access Permission in the settings'**
  String get fileSaveError;

  /// Fallback Text if any case even altText of te image can't be displayed or isn't provided
  ///
  /// In en, this message translates to:
  /// **'Unable to Display the Image'**
  String get imageAlternateTextFallback;

  /// Hint Text for Input Fields
  ///
  /// In en, this message translates to:
  /// **'example'**
  String get example;

  /// Text Field Title of The Link Dialog Box
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get linkDialogTextTitle;

  /// Link Field Title of The Link Dialog Box
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkDialogLinkTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
