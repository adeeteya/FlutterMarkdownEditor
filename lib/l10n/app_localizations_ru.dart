// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get ok => 'хорошо';

  @override
  String get yes => 'Да';

  @override
  String get cancel => 'Отмена';

  @override
  String get appTitle => 'Редактор Markdown';

  @override
  String get previewToolTip => 'Предпросмотр';

  @override
  String get switchThemeMenuItem => 'Сменить тему';

  @override
  String get switchViewMenuItem => 'Сменить вид';

  @override
  String get openFileMenuItem => 'Открыть';

  @override
  String get defaultFileName => 'Маркдаун';

  @override
  String get markdownTextInputLabel =>
      'Введите здесь свой текст в формате Маркдаун';

  @override
  String get storagePermission => 'Разрешение на хранение';

  @override
  String get storagePermissionContent =>
      'Пожалуйста, разрешите доступ к внешнему хранилищу на следующем экране, чтобы открывать, редактировать и сохранять файлы в формате Маркдаун.';

  @override
  String get error => 'Ошибка';

  @override
  String get unableToOpenFileError =>
      'Не удалось открыть файл, попробуйте открыть его из опции Открыть файл в меню';

  @override
  String get unableToOpenFileFromMenuError => 'Не удалось открыть файл';

  @override
  String get emptyInputTextContent => 'Пожалуйста, введите текст';

  @override
  String get clear => 'Очистить';

  @override
  String get clearAllTitle => 'Очистить все';

  @override
  String get clearAllContent => 'Вы уверены, что хотите очистить весь текст?';

  @override
  String get saveFileDialogTitle => 'Введите имя файла';

  @override
  String get saveFileDialogHintText => 'Имя файла';

  @override
  String get save => 'Сохранить';

  @override
  String fileSaveSuccess(String filePath) {
    return 'Файл успешно сохранен в $filePath';
  }

  @override
  String get fileSaveError =>
      'Ошибка сохранения файла. Попробуйте предоставить разрешение на доступ к файлам в настройках';

  @override
  String get imageAlternateTextFallback => 'Невозможно отобразить изображение';

  @override
  String get example => 'Пример';

  @override
  String get linkDialogTextTitle => 'Текст';

  @override
  String get linkDialogLinkTitle => 'Ссылка';

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
