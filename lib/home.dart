import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html2pdf;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor/device_preference_notifier.dart';
import 'package:markdown_editor/l10n/generated/app_localizations.dart';
import 'package:markdown_editor/widgets/MarkdownBody/custom_checkbox.dart';
import 'package:markdown_editor/widgets/MarkdownBody/custom_image_config.dart';
import 'package:markdown_editor/widgets/MarkdownBody/custom_text_node.dart';
import 'package:markdown_editor/widgets/MarkdownBody/latex_node.dart';
import 'package:markdown_editor/widgets/MarkdownTextInput/markdown_text_input.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuItem { switchTheme, switchView, open, clear, save, print, donate }

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
  static final RegExp _taskListLinePattern = RegExp(
    r'^(?:[-+*]|\d+[.)])\s+\[(?: |x|X)\]',
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
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(AppLocalizations.of(context)!.unableToOpenFileError),
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
        initialDirectory:
            widget.devicePreferenceNotifier.value.defaultFolderPath,
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
        final folderPath = _filePath.substring(
          0,
          _filePath.lastIndexOf(Platform.pathSeparator),
        );
        unawaited(
          widget.devicePreferenceNotifier.setDefaultFolderPath(folderPath),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
      builder: (context) => AlertDialog(
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
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.saveFileDialogTitle,
        fileName: (!kIsWeb && Platform.isWindows) ? null : "$_fileName.md",
        initialDirectory:
            widget.devicePreferenceNotifier.value.defaultFolderPath,
        type: FileType.custom,
        allowedExtensions: ['md'],
        bytes: utf8.encode(_inputText),
      );
      if (filePath != null) {
        final folderPath = filePath.substring(
          0,
          filePath.lastIndexOf(Platform.pathSeparator),
        );
        unawaited(
          widget.devicePreferenceNotifier.setDefaultFolderPath(folderPath),
        );
      }
    }
  }

  Future<void> _printFile() async {
    if (_inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyInputTextContent),
        ),
      );
      return;
    } else {
      final htmlFromMarkdown = md.markdownToHtml(_inputText);
      await Printing.layoutPdf(
        usePrinterSettings: true,
        onLayout: (format) async {
          final pdf = pw.Document();
          final widgets = await html2pdf.HTMLToPdf().convert(htmlFromMarkdown);
          pdf.addPage(pw.MultiPage(build: (context) => widgets));
          return pdf.save();
        },
      );
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.confirmAppExitTitle),
              content: Text(
                AppLocalizations.of(context)!.confirmAppExitContent,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  Widget _markdownPreviewWidget() {
    final isDark = widget.devicePreferenceNotifier.value.isDarkMode;
    final config = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    int checkboxIndex = -1;
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
            child: MarkdownBlock(
              data: _inputText,
              generator: MarkdownGenerator(
                generators: [latexGenerator],
                inlineSyntaxList: [LatexSyntax()],
                textGenerator: (node, config, visitor) =>
                    CustomTextNode(node.textContent, config, visitor),
                richTextBuilder: Text.rich,
              ),
              config: config.copy(
                configs: [
                  CustomImgConfig(),
                  CheckBoxConfig(
                    builder: (checked) {
                      checkboxIndex++;
                      final currentIndex = checkboxIndex;
                      return CustomCheckbox(
                        key: ValueKey('markdown-task-checkbox-$currentIndex'),
                        checked: checked,
                        onChanged: () => _toggleTaskListCheckbox(currentIndex),
                      );
                    },
                  ),
                ],
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onHorizontalDragEnd: (drag) {
            if (drag.primaryVelocity == null) {
              return;
            }
            setState(() {
              _isPreview = !_isPreview;
            });
          },
          child: _isPreview
              ? _markdownPreviewWidget()
              : MarkdownTextInput(
                  (String value) {
                    setState(() {
                      _inputText = value;
                    });
                  },
                  _inputText,
                  controller: _textEditingController,
                  label: AppLocalizations.of(context)!.markdownTextInputLabel,
                ),
        ),
      ),
    );
  }

  List<int> _taskListMarkerPositions(String text) {
    final positions = <int>[];
    final lines = text.split('\n');
    var offset = 0;

    for (final line in lines) {
      var sanitizedLine = line;
      if (sanitizedLine.endsWith('\r')) {
        sanitizedLine = sanitizedLine.substring(0, sanitizedLine.length - 1);
      }
      sanitizedLine = sanitizedLine.trimLeft();
      while (sanitizedLine.startsWith('>')) {
        sanitizedLine = sanitizedLine.substring(1).trimLeft();
      }
      if (_taskListLinePattern.hasMatch(sanitizedLine)) {
        final bracketIndex = line.indexOf('[');
        if (bracketIndex != -1) {
          positions.add(offset + bracketIndex);
        }
      }
      offset += line.length + 1;
    }

    return positions;
  }

  void _toggleTaskListCheckbox(int index) {
    final markerPositions = _taskListMarkerPositions(_inputText);
    if (index < 0 || index >= markerPositions.length) {
      return;
    }
    final markerStart = markerPositions[index];
    if (markerStart + 2 >= _inputText.length) {
      return;
    }
    final currentState = _inputText[markerStart + 1];
    final newState = (currentState == 'x' || currentState == 'X') ? ' ' : 'x';
    final updatedText = _inputText.replaceRange(
      markerStart,
      markerStart + 3,
      '[$newState]',
    );
    final currentSelection = _textEditingController.selection;
    final collapsedSelection = currentSelection.isValid
        ? TextSelection(
            baseOffset: math.min(
              currentSelection.baseOffset,
              updatedText.length,
            ),
            extentOffset: math.min(
              currentSelection.extentOffset,
              updatedText.length,
            ),
          )
        : TextSelection.collapsed(offset: updatedText.length);
    setState(() {
      _inputText = updatedText;
      _textEditingController.value = TextEditingValue(
        text: updatedText,
        selection: collapsedSelection,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _showExitConfirmationDialog();
          if (shouldPop && context.mounted) {
            await SystemNavigator.pop(animated: true);
          }
        },
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
                    case MenuItem.print:
                      await _printFile();
                      break;
                    case MenuItem.donate:
                      await launchUrl(
                        Uri.parse("https://buymeacoffee.com/adeeteya"),
                        mode: LaunchMode.externalApplication,
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
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
                        Text(AppLocalizations.of(context)!.switchThemeMenuItem),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: MenuItem.switchView,
                    child: Row(
                      children: [
                        const Icon(Icons.rotate_left),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.switchViewMenuItem),
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
                  PopupMenuItem(
                    value: MenuItem.print,
                    child: Row(
                      children: [
                        const Icon(Icons.print),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.print),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: MenuItem.donate,
                    child: Row(
                      children: [
                        const Icon(Icons.volunteer_activism),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.donate),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : (widget.devicePreferenceNotifier.value.isSplitLayout)
              ? _splitView()
              : _fullView(),
        ),
      ),
    );
  }
}
