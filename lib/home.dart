import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_editor/device_preference_notifier.dart';
import 'package:markdown_editor/l10n/generated/app_localizations.dart';
import 'package:markdown_editor/widgets/MarkdownTextInput/markdown_text_input.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

enum MenuItem { switchTheme, switchView, open, clear, save }

class Home extends StatefulWidget {
  final DevicePreferenceNotifier devicePreferenceNotifier;
  const Home({super.key, required this.devicePreferenceNotifier});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const _methodChannel = MethodChannel(
    "com.adeeteya.markdown_editor/channel",
  );
  String _filePath = "/storage/emulated/0/Download";
  String _fileName = 'Markdown';
  bool _isPreview = false;
  bool _isLoading = true;
  String _inputText = '';
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getFileContents();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _switchPreview() {
    setState(() {
      _isPreview = !_isPreview;
    });
  }

  Future<void> _getFileContents() async {
    try {
      final fileContent = await _methodChannel.invokeMethod<String>(
        'getFileContent',
      );

      _inputText = fileContent ?? '';
      _textEditingController.text = _inputText;
      setState(() {});
    } on MissingPluginException {
      debugPrint("Method channel not available on this platform");
    } catch (e) {
      debugPrint("Error getting file content: $e");
      if (mounted) {
        await showDialog(
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openFilePicker() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
      if (result != null) {
        _filePath = result.files.single.path ?? "";
        _fileName = _filePath.substring(
          _filePath.lastIndexOf("/") + 1,
          _filePath.lastIndexOf("."),
        );
        final File file = File(_filePath);
        _inputText = await file.readAsString();
        _textEditingController.text = _inputText;
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
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

  Future<void> _clearText() async {
    if (_inputText.isEmpty) {
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
                    _inputText = "";
                    _textEditingController.clear();
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          ),
    );
  }

  Future<void> _saveFile() async {
    if (_inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    } else {
      await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.saveFileDialogTitle,
        fileName: (!kIsWeb && Platform.isWindows) ? null : "$_fileName.md",
        type: FileType.custom,
        allowedExtensions: ['md'],
        bytes: utf8.encode(_inputText),
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
          controller: _scrollController,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            child: MarkdownBlock(data: _inputText),
          ),
        ),
      ),
    );
  }

  Widget _splitView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 5),
      child: Column(
        children: [
          Expanded(child: _markdownPreviewWidget()),
          const SizedBox(height: 5),
          MarkdownTextInput(
            (String value) {
              setState(() {
                _inputText = value;
              });
            },
            _inputText,
            controller: _textEditingController,
            maxLines: 8,
            label: AppLocalizations.of(context)!.markdownTextInputLabel,
          ),
        ],
      ),
    );
  }

  Widget _fullView() {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        child:
            _isPreview
                ? _markdownPreviewWidget()
                : SizedBox(
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: MarkdownTextInput(
                      (String value) {
                        setState(() {
                          _inputText = value;
                        });
                      },
                      _inputText,
                      controller: _textEditingController,
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
            if (!widget.devicePreferenceNotifier.value.isSplitLayout)
              IconButton(
                onPressed: _switchPreview,
                tooltip: AppLocalizations.of(context)!.previewToolTip,
                icon: Icon(
                  _isPreview ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            PopupMenuButton<MenuItem>(
              onSelected: (selectedMenuItem) async {
                switch (selectedMenuItem) {
                  case MenuItem.switchTheme:
                    await widget.devicePreferenceNotifier.toggleTheme();
                    break;
                  case MenuItem.switchView:
                    await widget.devicePreferenceNotifier.toggleLayout();
                    break;
                  case MenuItem.open:
                    await _openFilePicker();
                    break;
                  case MenuItem.clear:
                    await _clearText();
                    break;
                  case MenuItem.save:
                    await _saveFile();
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
            _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : (widget.devicePreferenceNotifier.value.isSplitLayout)
                ? _splitView()
                : _fullView(),
      ),
    );
  }
}
