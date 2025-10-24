import 'package:flutter/material.dart';

class Reactive {
  static void showUndoSnackBar({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: 'Desfazer', onPressed: onUndo),
      ),
    );
  }
}
