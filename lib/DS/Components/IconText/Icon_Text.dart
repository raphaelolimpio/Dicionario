import 'package:dicionario/DS/Components/Icons/Icon_Custom.dart';
import 'package:dicionario/DS/Components/Icons/Icon_view_Model.dart';
import 'package:dicionario/DS/Components/Text/StructuredText%20.dart';
import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final IconViewModel? iconModel;
  final String label;
  final String text;
  final TextStyle? style;
  final int? maxLines;

  const IconTextRow({
    Key? key,
    this.iconModel,
    this.label = "",
    required this.text,
    this.maxLines = 3,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty && text.isEmpty) {
      return const SizedBox.shrink();
    }

    final baseTextStyle = const TextStyle(fontSize: 18, color: Colors.black87);
    final labelStyle = baseTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final hasBullets = text.contains('•') || text.contains('●');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconModel != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2.0),
              child: IconCustom(viewModel: iconModel!),
            ),
          Expanded(
            child: hasBullets
    ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(label, style: labelStyle),
            ),
          StructuredText(
            text: text,
            style: style ?? baseTextStyle,
          ),
        ],
      )
    : Text.rich(
        TextSpan(
          style: baseTextStyle,
          children: [
            if (label.isNotEmpty)
              TextSpan(text: '$label ', style: labelStyle),
            TextSpan(text: text, style: style),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
          ),
        ],
      ),
    );
  }
}
