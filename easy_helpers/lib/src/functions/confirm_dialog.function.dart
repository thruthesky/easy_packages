import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';

/// Confirm dialgo
///
/// It requires build context.
///
/// Return true if the user taps on the 'Yes' button.
Future<bool?> confirm({
  required BuildContext context,
  required Widget title,
  Widget? subtitle,
  required Widget message,
}) {
  return
      //  HouseService.instance.confirmDialog
      //         ?.call(context: context, title: title, message: message) ??
      showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDialog(
        title: title,
        subtitle: subtitle,
        message: message,
      );
    },
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.message,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null) ...[
            subtitle!,
            const SizedBox(height: 24),
          ],
          message,
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('no'.t),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('yes'.t),
        ),
      ],
    );
  }
}
