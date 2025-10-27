import 'package:flutter/material.dart';

class ReturnButton extends StatefulWidget {
  final String? fallbackRouteName;
  final bool popToFirstIfNoBack;
  final VoidCallback? onReturn;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Duration debounceDuration;

  const ReturnButton({
    Key? key,
    this.fallbackRouteName,
    this.popToFirstIfNoBack = true,
    this.onReturn,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.debounceDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  State<ReturnButton> createState() => _ReturnButtonState();
}

class _ReturnButtonState extends State<ReturnButton> {
  bool _processing = false;

  Future<void> _handlePressed() async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      if (widget.onReturn != null) {
        widget.onReturn!();
      } else {
        final nav = Navigator.of(context);
        if (nav.canPop()) {
          nav.pop();
        } else if (widget.popToFirstIfNoBack) {
          nav.popUntil((r) => r.isFirst);
        } else if (widget.fallbackRouteName != null) {
          nav.pushNamedAndRemoveUntil(widget.fallbackRouteName!, (r) => false);
        }
      }
    } finally {
      await Future.delayed(widget.debounceDuration);
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _processing ? null : _handlePressed,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: widget.foregroundColor ?? Colors.white,
      elevation: widget.elevation,
      tooltip: 'Voltar',
      child: widget.icon ?? const Icon(Icons.arrow_back),
    );
  }
}