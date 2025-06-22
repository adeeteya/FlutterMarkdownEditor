// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get yes => 'Sim';

  @override
  String get cancel => 'Cancelar';

  @override
  String get appTitle => 'Editor de Markdown';

  @override
  String get previewToolTip => 'Pré-visualização';

  @override
  String get switchThemeMenuItem => 'Trocar Tema';

  @override
  String get switchViewMenuItem => 'Trocar Visualização';

  @override
  String get openFileMenuItem => 'Abrir';

  @override
  String get defaultFileName => 'Markdown';

  @override
  String get markdownTextInputLabel => 'Digite seu texto em Markdown aqui';

  @override
  String get storagePermission => 'Permissão de armazenamento';

  @override
  String get storagePermissionContent =>
      'Por favor, permita as permissões de armazenamento externo na próxima tela para poder abrir, editar e salvar arquivos markdown.';

  @override
  String get error => 'Erro';

  @override
  String get unableToOpenFileError =>
      'Não é possível abrir o arquivo, tente abri-lo na opção de arquivo aberto no menu.';

  @override
  String get unableToOpenFileFromMenuError => 'Não é possível abrir o arquivo';

  @override
  String get emptyInputTextContent => 'Por favor, digite algum texto';

  @override
  String get clear => 'Limpar';

  @override
  String get clearAllTitle => 'Limpar tudo';

  @override
  String get clearAllContent =>
      'Tem certeza de que deseja limpar todo o texto?';

  @override
  String get saveFileDialogTitle => 'Digite o nome do arquivo';

  @override
  String get saveFileDialogHintText => 'Nome do arquivo';

  @override
  String get save => 'Salvar';

  @override
  String fileSaveSuccess(String filePath) {
    return 'Arquivo salvo com sucesso em $filePath';
  }

  @override
  String get fileSaveError =>
      'Erro ao salvar o arquivo, tente conceder permissão de acesso ao arquivo nas configurações.';

  @override
  String get imageAlternateTextFallback => 'Não é possível exibir a imagem';

  @override
  String get example => 'exemplo';

  @override
  String get linkDialogTextTitle => 'Texto';

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
