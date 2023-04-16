import 'package:flutter/material.dart';

extension AppSnackbar on BuildContext {
  void snackbar(
    String content, {
    Color? backgroundColor,
    String? labelText,
    TextStyle? contentStyle,
    Color? labelTextColor,
  }) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Theme.of(this).primaryColor,
        content: Text(
          content,
          style: contentStyle,
        ),
        action: SnackBarAction(
          label: labelText ?? 'kapat',
          textColor: labelTextColor ?? Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(this).clearSnackBars();
            // Some code to undo the change.
          },
        ),
      ),
    );
  }
}
