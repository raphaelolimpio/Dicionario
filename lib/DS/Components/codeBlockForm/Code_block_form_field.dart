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
  final bool enabled;

  const CodeBlockFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.maxLines = 4,
    this.label = 'bash',
    this.hintText,
    this.validator,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            maxLines: maxLines,
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