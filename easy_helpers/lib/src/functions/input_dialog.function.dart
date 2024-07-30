import 'package:flutter/material.dart';

/// Prompt a dialog to get user input.
///
/// [context] is the build context.
///
/// [title] is the title of the dialog.
///
/// [subtitle] is the subtitle of the dialog.
///
/// [hintText] is the hintText of the input.
///
/// [initialValue] is the initial value of the input field.
///
/// [minLines] is the minLines of TextField
///
/// [maxLines] is the maxLines of TextField
///
/// Returns the user input.
///
/// Used in:
/// - admin.messaging.screen.dart
Future<String?> input({
  required BuildContext context,
  required Widget title,
  Widget? subtitle,
  required String hintText,
  String? initialValue,
  int? minLines,
  int? maxLines,
}) {
  return
      //  HouseService.instance.inputDialog?.call(
      //         context: context,
      //         title: title,
      //         subtitle: subtitle,
      //         hintText: hintText,
      //         minLines: minLines,
      //         maxLines: maxLines,
      //         initialValue: initialValue) ??
      showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      final controller = TextEditingController(text: initialValue);
      return AlertDialog(
        title: title,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null) ...[
              subtitle,
              const SizedBox(height: 24),
            ],
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              minLines: minLines,
              maxLines: maxLines,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('ok'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel'),
          ),
        ],
      );
    },
  );
}
