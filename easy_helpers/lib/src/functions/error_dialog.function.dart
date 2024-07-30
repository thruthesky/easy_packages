import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, this.title, required this.message});

  final Widget? title;
  final Widget message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title ??
          Text(
            'Error',
            style: Theme.of(context).textTheme.titleMedium,
          ),
      content: message,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ok'),
        ),
      ],
    );
  }
}

/// Display an alert box.
///
/// It requires build context where [toast] does not.
///
Future error({
  required BuildContext context,
  Widget? title,
  required Widget message,
}) {
  return
      //  HouseService.instance.errorDialog?.call(
      //       context: context,
      //       title: title,
      //       message: message,
      //     ) ??
      showDialog(
    context: context,
    builder: (BuildContext context) {
      return ErrorDialog(
        title: title,
        message: message,
      );
    },
  );
}
