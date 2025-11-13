import 'package:dicionario/shared/color.dart';
import 'package:flutter/material.dart';

class StructuredText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const StructuredText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        style ?? TextStyle(fontSize: 18, color: Colors.black87);
    final cleanedText = text
        .replaceAll('\n', ' ')
        .replaceAll('• ', '•')
        .replaceAll(' •', '•')
        .replaceAll('● ', '●')
        .replaceAll(' ●', '●');

    final parts = cleanedText
        .split(RegExp(r'[•●]'))
        .map((e) => e.trim())
        .toList();

    final firstPart = parts.first;
    final bulletItems = parts.skip(1).where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (firstPart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(firstPart, style: defaultStyle),
          ),
        if (bulletItems.isNotEmpty) ...[
          const SizedBox(height: 4),
          ...bulletItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 30, height: 1.3, fontWeight: FontWeight.bold, color: BlackIconColor)),
                  Expanded(child: Text(item, style: defaultStyle)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
