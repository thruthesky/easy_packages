import 'package:flutter/material.dart';

/// Shows an alert dialog with a title and a message.
Future<void> alert({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  return
      // TODO: let it be customizable by HelperService.instance.init(alert: ...)
      showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('close'),
          ),
        ],
      );
    },
  );
}
