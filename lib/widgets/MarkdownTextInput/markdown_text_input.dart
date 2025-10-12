import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editor/l10n/generated/app_localizations.dart';
import 'package:markdown_editor/widgets/MarkdownTextInput/format_markdown.dart';

class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optional controller to manage the input
  final TextEditingController? controller;

  /// Overrides input text style
  final TextStyle? textStyle;

  /// If you prefer to use the dialog to insert links, you can choose to use the markdown syntax directly by setting [insertLinksByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertLinksByDialog;

  /// Constructor for [MarkdownTextInput]
  const MarkdownTextInput(
    this.onTextChanged,
    this.initialValue, {
    super.key,
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines,
    this.actions = const [
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.heading,
      MarkdownType.link,
      MarkdownType.list,
      MarkdownType.strikethrough,
      MarkdownType.code,
      MarkdownType.blockquote,
      MarkdownType.separator,
      MarkdownType.image,
      MarkdownType.table,
    ],
    this.textStyle,
    this.controller,
    this.insertLinksByDialog = true,
  });

  @override
  State<MarkdownTextInput> createState() => _MarkdownTextInputState();
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  late final TextEditingController _controller;
  TextSelection _textSelection = const TextSelection(
    baseOffset: 0,
    extentOffset: 0,
  );
  final FocusNode _focusNode = FocusNode();

  void onTap(
    MarkdownType type, {
    int titleSize = 1,
    String? link,
    String? selectedText,
    int tableRows = 3,
    int tableCols = 3,
  }) {
    final basePosition = _textSelection.baseOffset;
    final noTextSelected =
        (_textSelection.baseOffset - _textSelection.extentOffset) == 0;

    final fromIndex = _textSelection.baseOffset;
    final toIndex = _textSelection.extentOffset;

    final result = FormatMarkdown.convertToMarkdown(
      type,
      _controller.text,
      fromIndex,
      toIndex,
      titleSize: titleSize,
      link: link,
      selectedText:
          selectedText ?? _controller.text.substring(fromIndex, toIndex),
      tableRows: tableRows,
      tableCols: tableCols,
    );

    _controller.value = _controller.value.copyWith(
      text: result.data,
      selection: TextSelection.collapsed(
        offset: basePosition + result.cursorIndex,
      ),
    );

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(
        offset: _controller.selection.end - result.replaceCursorIndex,
      );
      _focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue;
    _controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() {
    if (_controller.selection.baseOffset != -1) {
      _textSelection = _controller.selection;
    }
    widget.onTextChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _basicInkwell(MarkdownType type, {Function? customOnTap}) {
    return Tooltip(
      message: type.title(context),
      child: InkWell(
        key: Key(type.key),
        onTap: () => customOnTap != null ? customOnTap() : onTap(type),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(type.icon),
        ),
      ),
    );
  }

  Widget actionWidget(MarkdownType type) {
    switch (type) {
      case MarkdownType.heading:
        return Tooltip(
          message: type.title(context),
          child: ExpandableNotifier(
            child: Expandable(
              key: const Key('H#_button'),
              collapsed: ExpandableButton(
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'H#',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              expanded: ColoredBox(
                color: Colors.white10,
                child: Row(
                  children: [
                    for (int i = 1; i <= 6; i++)
                      InkWell(
                        key: Key('H${i}_button'),
                        onTap: () => onTap(MarkdownType.heading, titleSize: i),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'H$i',
                            style: TextStyle(
                              fontSize: (18 - i).toDouble(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ExpandableButton(
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case MarkdownType.link:
        return _basicInkwell(
          type,
          customOnTap: !widget.insertLinksByDialog
              ? null
              : () async {
                  final text = _controller.text.substring(
                    _textSelection.baseOffset,
                    _textSelection.extentOffset,
                  );

                  final textController = TextEditingController()..text = text;
                  final linkController = TextEditingController();
                  final textFocus = FocusNode();
                  final linkFocus = FocusNode();

                  final color = Theme.of(context).colorScheme.secondary;

                  await showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.enterLinkTextDialogTitle,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                hintText: 'example',
                                label: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.linkDialogTextTitle,
                                ),
                                labelStyle: TextStyle(color: color),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color,
                                    width: 2,
                                  ),
                                ),
                              ),
                              autofocus: text.isEmpty,
                              focusNode: textFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (value) {
                                textFocus.unfocus();
                                FocusScope.of(context).requestFocus(linkFocus);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: linkController,
                              decoration: InputDecoration(
                                hintText: 'https://www.example.com',
                                label: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.linkDialogLinkTitle,
                                ),
                                labelStyle: TextStyle(color: color),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color,
                                    width: 2,
                                  ),
                                ),
                              ),
                              autofocus: text.isNotEmpty,
                              focusNode: linkFocus,
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onTap(
                                type,
                                link: linkController.text,
                                selectedText: textController.text,
                              );
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.ok),
                          ),
                        ],
                      );
                    },
                  );
                },
        );
      case MarkdownType.table:
        return Tooltip(
          message: type.title(context),
          child: InkWell(
            key: const Key('table_button'),
            onTap: () async {
              final res = await showDialog<_TableConfig?>(
                context: context,
                builder: (ctx) => _TableDialog(),
              );
              if (res != null) {
                onTap(
                  MarkdownType.table,
                  tableRows: res.rows,
                  tableCols: res.cols,
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.table_chart_rounded),
            ),
          ),
        );
      default:
        return _basicInkwell(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: use_decorated_box
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 44,
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.actions.map(actionWidget).toList(),
              ),
            ),
          ),
          const Divider(height: 0),
          Flexible(
            child: TextFormField(
              focusNode: _focusNode,
              textInputAction: TextInputAction.newline,
              maxLines: widget.maxLines,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              validator: widget.validators != null
                  ? (value) => widget.validators!(value)
                  : null,
              style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
              cursorColor: Theme.of(context).colorScheme.primary,
              textDirection: widget.textDirection,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                hintText: widget.label,
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(63, 61, 86, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableConfig {
  final int rows;
  final int cols;
  const _TableConfig({required this.rows, required this.cols});
}

class _TableDialog extends StatefulWidget {
  @override
  State<_TableDialog> createState() => _TableDialogState();
}

class _TableDialogState extends State<_TableDialog> {
  int _rows = 3;
  int _cols = 3;

  Widget _numberField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (s) => onChanged(int.tryParse(s) ?? value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(loc?.table ?? 'Table'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Row(
        children: [
          Expanded(
            child: _numberField(
              label: loc?.rows ?? 'Rows',
              value: _rows,
              onChanged: (v) => setState(() => _rows = v),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _numberField(
              label: loc?.columns ?? 'Columns',
              value: _cols,
              onChanged: (v) => setState(() => _cols = v),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final sanitizedRows = _rows.clamp(1, 50);
            final sanitizedCols = _cols.clamp(1, 20);
            Navigator.pop(
              context,
              _TableConfig(rows: sanitizedRows, cols: sanitizedCols),
            );
          },
          child: Text(loc?.insert ?? 'Insert'),
        ),
      ],
    );
  }
}
