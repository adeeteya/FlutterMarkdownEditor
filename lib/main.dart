import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor/device_preference_notifier.dart';
import 'package:markdown_editor/widgets/MarkdownTextInput/markdown_text_input.dart';
import 'package:url_launcher/url_launcher.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  final DevicePreferenceNotifier devicePreferenceNotifier =
      DevicePreferenceNotifier();
  await devicePreferenceNotifier.loadDevicePreferences();

  runApp(MarkdownEditorApp(devicePreferenceNotifier: devicePreferenceNotifier));
}

class MarkdownEditorApp extends StatelessWidget {
  final DevicePreferenceNotifier devicePreferenceNotifier;
  const MarkdownEditorApp({super.key, required this.devicePreferenceNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DevicePreferences>(
      valueListenable: devicePreferenceNotifier,
      builder: (context, devicePreference, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Markdown Editor',
          themeMode:
              devicePreference.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.indigo,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('es'),
            Locale('fr'),
            Locale('hi'),
            Locale('ja'),
            Locale('pt'),
            Locale('ru'),
            Locale('zh'),
          ],
          home: Home(devicePreferenceNotifier: devicePreferenceNotifier),
        );
      },
    );
  }
}

enum MenuItem { switchTheme, switchView, open, clear, save }

class Home extends StatefulWidget {
  final DevicePreferenceNotifier devicePreferenceNotifier;
  const Home({super.key, required this.devicePreferenceNotifier});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _inputTextEditingController =
      TextEditingController();
  final _methodChannel = MethodChannel("Markdown_Editor_Channel");
  String _filePath = "/storage/emulated/0/Download";
  String _fileName = 'Markdown';
  bool _isPreview = false;

  @override
  void initState() {
    super.initState();
    _getFileContents();
  }

  @override
  void dispose() {
    _inputTextEditingController.dispose();
    super.dispose();
  }

  void _switchPreview() {
    setState(() {
      _isPreview = !_isPreview;
    });
  }

  void _getFileContents() async {
    await _methodChannel.invokeMethod<String>('getFileContent').then((
      fileContent,
    ) async {
      try {
        _inputTextEditingController.text = fileContent ?? '';
        setState(() {});
      } catch (e) {
        if (fileContent == null) {
          return;
        }
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.error),
                  content: Text(
                    AppLocalizations.of(context)!.unableToOpenFileError,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ),
          );
        }
      }
    });
  }

  void _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
      if (result != null) {
        _filePath = result.files.single.path ?? "";
        _fileName = _filePath.substring(
          _filePath.lastIndexOf("/") + 1,
          _filePath.lastIndexOf("."),
        );
        File file = File(_filePath);
        _inputTextEditingController.text = await file.readAsString();
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(
                  AppLocalizations.of(context)!.unableToOpenFileFromMenuError,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              ),
        );
      }
    }
  }

  void _clearText() async {
    if (_inputTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.clearAllTitle),
            content: Text(AppLocalizations.of(context)!.clearAllContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  _inputTextEditingController.clear();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          ),
    );
  }

  void _saveFile() async {
    if (_inputTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    } else {
      FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.saveFileDialogTitle,
        fileName: "$_fileName.md",
        type: FileType.custom,
        allowedExtensions: ['md'],
        bytes: utf8.encode(_inputTextEditingController.text),
      );
    }
  }

  Widget _markdownPreviewWidget() {
    return Card(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Scrollbar(
          interactive: true,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: MarkdownBody(
              data: _inputTextEditingController.text,
              shrinkWrap: true,
              softLineBreak: true,
              sizedImageBuilder: (imageConfig) {
                return Image.network(
                  imageConfig.uri.toString(),
                  errorBuilder: (_, _, _) {
                    return Text(
                      imageConfig.alt ??
                          AppLocalizations.of(
                            context,
                          )!.imageAlternateTextFallback,
                    );
                  },
                );
              },
              onTapLink: (i, j, k) {
                launchUrl(Uri.parse(j ?? ""));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _verticalView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 5),
      child: Column(
        children: [
          Expanded(child: _markdownPreviewWidget()),
          const SizedBox(height: 5),
          MarkdownTextInput(
            (String value) {
              _inputTextEditingController.text = value;
              setState(() {});
            },
            _inputTextEditingController.text,
            controller: _inputTextEditingController,
            maxLines: 8,
            label: AppLocalizations.of(context)!.markdownTextInputLabel,
          ),
        ],
      ),
    );
  }

  Widget _hiddenView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        child:
            (_isPreview)
                ? _markdownPreviewWidget()
                : Expanded(
                  child: SingleChildScrollView(
                    child: MarkdownTextInput(
                      (String value) {
                        _inputTextEditingController.text = value;
                        setState(() {});
                      },
                      _inputTextEditingController.text,
                      controller: _inputTextEditingController,
                      label:
                          AppLocalizations.of(context)!.markdownTextInputLabel,
                    ),
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.appTitle),
          actions: [
            if (!widget.devicePreferenceNotifier.value.isVerticalLayout)
              IconButton(
                onPressed: _switchPreview,
                tooltip: AppLocalizations.of(context)!.previewToolTip,
                icon: Icon(
                  _isPreview ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            PopupMenuButton<MenuItem>(
              onSelected: (selectedMenuItem) {
                switch (selectedMenuItem) {
                  case MenuItem.switchTheme:
                    widget.devicePreferenceNotifier.toggleTheme();
                    break;
                  case MenuItem.switchView:
                    widget.devicePreferenceNotifier.toggleLayout();
                    break;
                  case MenuItem.open:
                    _openFilePicker();
                    break;
                  case MenuItem.clear:
                    _clearText();
                    break;
                  case MenuItem.save:
                    _saveFile();
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: MenuItem.switchTheme,
                      child: Row(
                        children: [
                          Icon(
                            widget.devicePreferenceNotifier.value.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.switchThemeMenuItem,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: MenuItem.switchView,
                      child: Row(
                        children: [
                          const Icon(Icons.rotate_left),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.switchViewMenuItem,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: MenuItem.open,
                      child: Row(
                        children: [
                          const Icon(Icons.file_open),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.openFileMenuItem),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: MenuItem.clear,
                      child: Row(
                        children: [
                          const Icon(Icons.clear_all),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.clear),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: MenuItem.save,
                      child: Row(
                        children: [
                          const Icon(Icons.save),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.save),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
        body:
            (widget.devicePreferenceNotifier.value.isVerticalLayout)
                ? _verticalView()
                : _hiddenView(),
      ),
    );
  }
}
