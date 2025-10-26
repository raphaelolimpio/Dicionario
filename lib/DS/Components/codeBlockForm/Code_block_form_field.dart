import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class CodeBlockFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final int maxLines;
  final String label;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool enabled;
  final bool autoGrow;

  const CodeBlockFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.maxLines = 4,
    this.label = 'bash',
    this.hintText,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.autoGrow = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboard = autoGrow ? TextInputType.multiline : keyboardType;
    final effectiveMaxLines = autoGrow ? null : maxLines;
    final effectiveMinLines = autoGrow ? 1 : (maxLines > 1 ? 1 : null);
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(top: 4.0, bottom: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: BashBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: BashTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: BashDividerColor, height: 10, thickness: 0.5),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            minLines: effectiveMinLines,
            maxLines: effectiveMaxLines,
            keyboardType: effectiveKeyboard,
            enabled: enabled,
            style: const TextStyle(
              color: WhiteTextColor,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: WhiteTextColor.withOpacity(0.6)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}