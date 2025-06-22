// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get ok => '好的';

  @override
  String get yes => '是的';

  @override
  String get cancel => '取消';

  @override
  String get appTitle => 'Markdown 编辑器';

  @override
  String get previewToolTip => '预览';

  @override
  String get switchThemeMenuItem => '切换主题';

  @override
  String get switchViewMenuItem => '切换视图';

  @override
  String get openFileMenuItem => '打开';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => '在此输入你的 Markdown 文本';

  @override
  String get storagePermission => '存储权限';

  @override
  String get storagePermissionContent =>
      '请在下一个界面上允许外部存储权限，以便能够打开、编辑和保存 Markdown 文件';

  @override
  String get error => '错误';

  @override
  String get unableToOpenFileError => '无法打开文件，请尝试从菜单的打开文件选项中打开它';

  @override
  String get unableToOpenFileFromMenuError => '无法打开文件';

  @override
  String get emptyInputTextContent => '请输入一些文本';

  @override
  String get clear => '清除';

  @override
  String get clearAllTitle => '全部清除';

  @override
  String get clearAllContent => '你确定要清除所有文本吗？';

  @override
  String get saveFileDialogTitle => '输入文件名';

  @override
  String get saveFileDialogHintText => '文件名';

  @override
  String get save => '保存';

  @override
  String fileSaveSuccess(String filePath) {
    return '文件已成功保存在$filePath';
  }

  @override
  String get fileSaveError => '保存文件时出错，请尝试在设置中授予文件访问权限';

  @override
  String get imageAlternateTextFallback => '无法显示图片';

  @override
  String get example => '例子';

  @override
  String get linkDialogTextTitle => '文本';

  @override
  String get linkDialogLinkTitle => '链接';

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
