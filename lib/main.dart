import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor/widgets/MarkdownTextInput/markdown_text_input.dart';
import 'package:permission_handler/permission_handler.dart';
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
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MarkdownEditorApp());
}

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier(super.value);

  void switchTheme() {
    value = !value;
    notifyListeners();
  }
}

ThemeNotifier isDarkNotifier = ThemeNotifier(
  PlatformDispatcher.instance.platformBrightness == Brightness.dark,
);

class MarkdownEditorApp extends StatelessWidget {
  const MarkdownEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkNotifier,
      builder: (context, isDarkTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Markdown Editor',
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
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
          home: const Home(),
        );
      },
    );
  }
}

enum MenuItem { switchTheme, switchView, open, clear, save }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final TextEditingController _inputTextEditingController =
      TextEditingController();
  static const platform = MethodChannel("Markdown_Editor_Channel");
  String filePath = "/storage/emulated/0/Download";
  String fileName = 'Markdown';
  String inputText = '';
  bool isVerticalView = true;
  bool isPreview = false;

  @override
  void initState() {
    requestPermissions();
    super.initState();
    getOpenFileUrl();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getOpenFileUrl();
    }
  }

  @override
  void dispose() {
    _inputTextEditingController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void switchView() {
    setState(() {
      isVerticalView = !isVerticalView;
    });
  }

  void switchPreview() {
    setState(() {
      isPreview = !isPreview;
    });
  }

  void getOpenFileUrl() async {
    await platform.invokeMethod("getOpenFileUrl").then((fileUrl) async {
      try {
        filePath = fileUrl as String;
        if (filePath.contains(":")) {
          filePath = filePath.split(":").last;
          filePath = "/storage/emulated/0/$filePath";
          fileName = filePath.substring(
            filePath.lastIndexOf("/") + 1,
            filePath.lastIndexOf("."),
          );
        }
        File file = File(filePath);
        inputText = await file.readAsString();
        _inputTextEditingController.text = inputText;
        setState(() {});
      } catch (e) {
        if (fileUrl == null) {
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

  void openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
      if (result != null) {
        filePath = result.files.single.path ?? "";
        fileName = filePath.substring(
          filePath.lastIndexOf("/") + 1,
          filePath.lastIndexOf("."),
        );
        File file = File(filePath);
        inputText = await file.readAsString();
        _inputTextEditingController.text = inputText;
        setState(() {});
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

  void clearText() async {
    if (inputText.isEmpty) {
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
                  setState(() {
                    inputText = "";
                  });
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

  void saveFileDialog() async {
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.saveFileDialogTitle),
              content: TextFormField(
                initialValue: fileName,
                keyboardType: TextInputType.name,
                onChanged: (val) {
                  fileName = val;
                  if (val.isEmpty) {
                    fileName = "Markdown";
                  }
                },
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.saveFileDialogHintText,
                  suffixText: ".md",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    await saveFile(fileName);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ),
      );
    }
  }

  Future saveFile(String fileName) async {
    if (filePath.contains(".md")) {
      filePath = filePath.substring(0, filePath.lastIndexOf("/"));
    }
    File file = File("$filePath/$fileName.md");
    try {
      await file.writeAsString(inputText);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.fileSaveSuccess(file.path),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.fileSaveError),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget markdownPreviewWidget() {
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
              data: inputText,
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

  Widget verticalView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 5),
      child: Column(
        children: [
          Expanded(child: markdownPreviewWidget()),
          const SizedBox(height: 5),
          MarkdownTextInput(
            (String value) => setState(() => inputText = value),
            inputText,
            controller: _inputTextEditingController,
            maxLines: 8,
            label: AppLocalizations.of(context)!.markdownTextInputLabel,
          ),
        ],
      ),
    );
  }

  Widget hiddenView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        child:
            (isPreview)
                ? markdownPreviewWidget()
                : Expanded(
                  child: SingleChildScrollView(
                    child: MarkdownTextInput(
                      (String value) => setState(() => inputText = value),
                      inputText,
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
            if (!isVerticalView)
              IconButton(
                onPressed: switchPreview,
                tooltip: AppLocalizations.of(context)!.previewToolTip,
                icon: Icon(isPreview ? Icons.visibility_off : Icons.visibility),
              ),
            PopupMenuButton<MenuItem>(
              onSelected: (selectedMenuItem) {
                switch (selectedMenuItem) {
                  case MenuItem.switchTheme:
                    isDarkNotifier.switchTheme();
                    break;
                  case MenuItem.switchView:
                    switchView();
                    break;
                  case MenuItem.open:
                    openFilePicker();
                    break;
                  case MenuItem.clear:
                    clearText();
                    break;
                  case MenuItem.save:
                    saveFileDialog();
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
                            isDarkNotifier.value
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
        body: (isVerticalView) ? verticalView() : hiddenView(),
      ),
    );
  }
}
