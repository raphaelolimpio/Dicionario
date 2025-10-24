import 'package:dicionario/shared/color.dart'; 
import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String? code;

  const CodeBlock({
    Key? key,
    this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (code == null || code!.isEmpty) {
      return const SizedBox.shrink();
    }

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
          const Text(
            'bash',
            style: TextStyle(
              color: BashTextColor, 
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: BashDividerColor, height: 10, thickness: 0.5), 
          Text(
            code!,
            style: const TextStyle(
              color: WhiteTextColor,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
