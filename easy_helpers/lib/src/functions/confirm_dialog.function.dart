import 'package:flutter/material.dart';

/// Confirm dialgo
///
/// It requires build context.
///
/// Return true if the user taps on the 'Yes' button.
Future<bool?> confirm({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return
      //  HouseService.instance.confirmDialog
      //         ?.call(context: context, title: title, message: message) ??
      showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('no'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('yes'),
          ),
        ],
      );
    },
  );
}
