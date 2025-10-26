import 'package:dicionario/DS/Components/Icons/Icon_Custom.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:flutter/material.dart';

class IconTextFormFieldRow extends StatelessWidget {
  final IconViewModel? iconModel;
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enabled;
  final bool requiredField;

  const IconTextFormFieldRow({
    Key? key,
    this.iconModel,
    this.label = "",
    this.controller,
    this.initialValue,
    this.hintText,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.requiredField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty && controller == null && (initialValue == null || initialValue!.isEmpty)) {
      return const SizedBox.shrink();
    }

    final labelStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconModel != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                  child: IconCustom(viewModel: iconModel!),
                ),
              if (label.isNotEmpty)
                Text(label, style: labelStyle),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            enabled: enabled,
            validator: (value) {
              if (requiredField && (value == null || value.trim().isEmpty)) {
                return 'Este campo é obrigatório';
              }
              if (validator != null) return validator!(value ?? '');
              return null;
            },
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
