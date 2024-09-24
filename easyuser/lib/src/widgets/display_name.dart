import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// DisplayName
///
/// Use this widget to display the user's display name.
class DisplayName extends StatelessWidget {
  const DisplayName({
    super.key,
    required this.uid,
    this.maxLines = 1,
    this.overflow,
  });

  final String uid;
  final int maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return UserField<String?>(
      uid: uid,
      field: User.field.displayName,
      builder: (displayName) {
        return Text(
          displayName ?? '',
          maxLines: maxLines,
          overflow: overflow,
          style: Theme.of(context).textTheme.labelMedium,
        );
      },
    );
  }
}
