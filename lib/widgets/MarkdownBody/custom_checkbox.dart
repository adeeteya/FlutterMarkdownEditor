import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool checked;
  final VoidCallback onChanged;

  const CustomCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Checkbox(
        value: checked,
        onChanged: (_) => onChanged(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
