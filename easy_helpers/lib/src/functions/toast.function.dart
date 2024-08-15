import 'package:easy_helpers/easy_helpers.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

/// Display a snackbar
///
/// When the body of the snackbar is tapped, [onTap] will be called with a callback that will hide the snackbar.
///
/// Call the function parameter passed on the callback to close the snackbar.
/// ```dart
/// toast( title: 'title',  message: 'message', onTap: (close) => close());
/// toast(  title: 'error title', message: 'error message',  error: true );
/// ```
ScaffoldFeatureController toast({
  required BuildContext context,
  Widget? title,
  required Widget message,
  Icon? icon,
  Duration duration = const Duration(seconds: 8),
  Function(Function)? onTap,
  bool? error,
  bool hideCloseButton = false,
  Color? backgroundColor,
  Color? foregroundColor,
  double runSpacing = 12,
}) {
  if (error == true) {
    backgroundColor ??= Theme.of(context).colorScheme.error;
    foregroundColor ??= Theme.of(context).colorScheme.onError;
  }

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: backgroundColor,
      // TODO
      elevation: 20,
      content: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (onTap == null) return;

                onTap(() {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                });
              },
              child: Row(children: [
                if (icon != null) ...[
                  Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(color: foregroundColor),
                    ),
                    child: icon,
                  ),
                  SizedBox(width: runSpacing),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) title,
                      message,
                    ],
                  ),
                ),
              ]),
            ),
          ),
          if (hideCloseButton == false)
            TextButton(
              onPressed: () {
                if (!context.mounted) {
                  dog('toast(): context is not mouned!');
                  return;
                }
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                'dismiss'.t,
                style: TextStyle(color: foregroundColor),
              ),
            )
        ],
      ),
    ),
  );
}

ScaffoldFeatureController errorToast({
  required BuildContext context,
  Widget? title,
  required Widget message,
  Icon? icon,
  Duration duration = const Duration(seconds: 8),
  Function(Function)? onTap,
  bool? error,
  bool hideCloseButton = false,
  Color? backgroundColor,
  Color? foregroundColor,
  double runSpacing = 12,
}) {
  return toast(
    context: context,
    title: title,
    message: message,
    icon: icon,
    duration: duration,
    onTap: onTap,
    error: true,
    hideCloseButton: hideCloseButton,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    runSpacing: runSpacing,
  );
}
