import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MarkdownEditorApp());

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier(super.value);

  void switchTheme() {
    value = !value;
    notifyListeners();
  }
}

ThemeNotifier isDarkNotifier = ThemeNotifier(
    SchedulerBinding.instance.window.platformBrightness == Brightness.dark);

class MarkdownEditorApp extends StatelessWidget {
  const MarkdownEditorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkNotifier,
      builder: (context, isDarkTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Markdown Editor",
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            primaryColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
          ),
          home: const Home(),
        );
      },
    );
  }
}

enum MenuItem {
  switchTheme,
  switchView,
  open,
  clear,
  save,
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
    await Permission.manageExternalStorage.status.then((status) {
      if (!status.isGranted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Storage Permission"),
            content: const Text(
                "Please allow external storage permissions on the next screen to be able to open, edit and save markdown files"),
            actions: [
              TextButton(
                onPressed: () async {
                  await Permission.manageExternalStorage
                      .request()
                      .then((_) => Navigator.pop(context));
                },
                child: const Text("Ok"),
              ),
            ],
          ),
        );
      }
    });
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
              filePath.lastIndexOf("/") + 1, filePath.lastIndexOf("."));
        }
        File file = File(filePath);
        inputText = await file.readAsString();
        _inputTextEditingController.text = inputText;
        setState(() {});
      } catch (e) {
        if (fileUrl == null) {
          return;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Unable to open the file, try opening it from open file option on the menu"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"),
              )
            ],
          ),
        );
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
            filePath.lastIndexOf("/") + 1, filePath.lastIndexOf("."));
        File file = File(filePath);
        inputText = await file.readAsString();
        _inputTextEditingController.text = inputText;
        setState(() {});
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Unable to open the file"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ok"),
            )
          ],
        ),
      );
    }
  }

  void clearText() async {
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter some text")));
      return;
    }
    FocusScope.of(context).unfocus();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All"),
        content: const Text("Are you sure do you want to clear all the text?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
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
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void saveFileDialog() async {
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter some text")));
      return;
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Enter the name of the file"),
          content: TextFormField(
            initialValue: fileName,
            keyboardType: TextInputType.name,
            onChanged: (val) {
              fileName = val;
              if (val.isEmpty) {
                fileName = "Markdown";
              }
            },
            decoration: const InputDecoration(
              hintText: "FileName",
              suffixText: ".md",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await saveFile(fileName)
                    .then((value) => Navigator.pop(context));
              },
              child: const Text("Save"),
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
      await file.writeAsString(inputText).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("File Saved successfully at ${file.path}"),
                duration: const Duration(seconds: 5),
              ),
            ),
          );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Error Saving the file, Try Granting File Access Permission in the settings"),
          duration: Duration(seconds: 5),
        ),
      );
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
              imageBuilder: (imageUri, _, alternateText) {
                return Image.network(
                  imageUri.toString(),
                  errorBuilder: (_, __, ___) {
                    return Text(alternateText ?? "Unable to Display the Image");
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
          Expanded(
            child: markdownPreviewWidget(),
          ),
          const SizedBox(height: 5),
          MarkdownTextInput(
            (String value) => setState(() => inputText = value),
            inputText,
            controller: _inputTextEditingController,
            maxLines: 4,
            label: 'Enter your markdown text here',
            actions: MarkdownType.values,
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
        child: (isPreview)
            ? markdownPreviewWidget()
            : MarkdownTextInput(
                (String value) => setState(() => inputText = value),
                inputText,
                controller: _inputTextEditingController,
                label: 'Enter your markdown text here',
                actions: MarkdownType.values,
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
          title: const Text("Markdown Editor"),
          actions: [
            if (!isVerticalView)
              IconButton(
                onPressed: switchPreview,
                tooltip: "Preview",
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
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: MenuItem.switchTheme,
                  child: Row(
                    children: [
                      Icon(isDarkNotifier.value
                          ? Icons.dark_mode
                          : Icons.light_mode),
                      const SizedBox(width: 8),
                      const Text("Switch Theme"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.switchView,
                  child: Row(
                    children: const [
                      Icon(Icons.rotate_left),
                      SizedBox(width: 8),
                      Text("Switch View"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.open,
                  child: Row(
                    children: const [
                      Icon(Icons.file_open),
                      SizedBox(width: 8),
                      Text("Open"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.clear,
                  child: Row(
                    children: const [
                      Icon(Icons.clear_all),
                      SizedBox(width: 8),
                      Text("Clear"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: MenuItem.save,
                  child: Row(
                    children: const [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text("Save"),
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
