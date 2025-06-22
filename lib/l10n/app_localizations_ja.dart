// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get ok => 'はい';

  @override
  String get yes => 'はい';

  @override
  String get cancel => 'キャンセル';

  @override
  String get appTitle => 'Markdownエディター';

  @override
  String get previewToolTip => 'プレビュー';

  @override
  String get switchThemeMenuItem => 'テーマを切り替える';

  @override
  String get switchViewMenuItem => 'ビューを切り替える';

  @override
  String get openFileMenuItem => '開く';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'ここにマークダウンテキストを入力してください';

  @override
  String get storagePermission => 'ストレージの許可';

  @override
  String get storagePermissionContent =>
      '次の画面で外部ストレージの許可を許可してください。マークダウンファイルを開いて、編集、保存できます。';

  @override
  String get error => 'エラー';

  @override
  String get unableToOpenFileError =>
      'ファイルを開けません。メニューの ファイルを開く ,オプションから開いてください。';

  @override
  String get unableToOpenFileFromMenuError => 'ファイルを開けません。';

  @override
  String get emptyInputTextContent => 'テキストを入力してください。';

  @override
  String get clear => 'クリア';

  @override
  String get clearAllTitle => 'すべてクリア';

  @override
  String get clearAllContent => 'すべてのテキストを消去してもよろしいですか？';

  @override
  String get saveFileDialogTitle => 'ファイル名を入力してください';

  @override
  String get saveFileDialogHintText => 'ファイル名';

  @override
  String get save => '保存';

  @override
  String fileSaveSuccess(String filePath) {
    return '$filePathにファイルが正常に保存されました';
  }

  @override
  String get fileSaveError => 'ファイルの保存中にエラーが発生しました。設定でファイルアクセス許可を付与してみてください。';

  @override
  String get imageAlternateTextFallback => '画像を表示できません';

  @override
  String get example => '例';

  @override
  String get linkDialogTextTitle => 'テキスト';

  @override
  String get linkDialogLinkTitle => 'リンク';
}
