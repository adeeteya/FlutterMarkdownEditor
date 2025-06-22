// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get ok => 'حسناً';

  @override
  String get yes => 'نعم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get appTitle => 'محرر Markdown';

  @override
  String get previewToolTip => 'المعاينة';

  @override
  String get switchThemeMenuItem => 'تبديل المظهر';

  @override
  String get switchViewMenuItem => 'تبديل العرض';

  @override
  String get openFileMenuItem => 'فتح';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'أدخل نص Markdown الخاص بك هنا';

  @override
  String get storagePermission => 'إذن التخزين';

  @override
  String get storagePermissionContent =>
      'يرجى السماح بإذن التخزين الخارجي على الشاشة التالية لتمكين فتح وتعديل وحفظ ملفات Markdown';

  @override
  String get error => 'خطأ';

  @override
  String get unableToOpenFileError =>
      'غير قادر على فتح الملف، جرب فتحه من خيار فتح الملف في القائمة';

  @override
  String get unableToOpenFileFromMenuError => 'غير قادر على فتح الملف';

  @override
  String get emptyInputTextContent => 'يرجى إدخال بعض النص';

  @override
  String get clear => 'مسح';

  @override
  String get clearAllTitle => 'مسح الكل';

  @override
  String get clearAllContent => 'هل أنت متأكد أنك تريد مسح كل النص؟';

  @override
  String get saveFileDialogTitle => 'أدخل اسم الملف';

  @override
  String get saveFileDialogHintText => 'اسم الملف';

  @override
  String get save => 'حفظ';

  @override
  String fileSaveSuccess(String filePath) {
    return 'تم حفظ الملف بنجاح في $filePath';
  }

  @override
  String get fileSaveError =>
      'خطأ في حفظ الملف، جرب منح إذن الوصول إلى الملف في الإعدادات';

  @override
  String get imageAlternateTextFallback => 'غير قادر على عرض الصورة';

  @override
  String get example => 'مثال';

  @override
  String get linkDialogTextTitle => 'نص';

  @override
  String get linkDialogLinkTitle => 'رابط';

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
