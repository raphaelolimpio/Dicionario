import 'package:flutter/material.dart';

class Reactive {
  Reactive._();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showUndoSnackBar({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
    String undoLabel = 'Desfazer',
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    final controller = messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: SnackBarAction(label: undoLabel, onPressed: onUndo),
      ),
    );
    return controller;
  }
}
