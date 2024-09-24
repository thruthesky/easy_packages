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
    this.style,
  });

  final String uid;
  final int maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

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
          // Originally, we have put here `Theme.of(context).textTheme.labelMedium`.
          // Sometimes, it is better to let the widget set the sizing.
          // For example in ListTile, we can let it decide the size of texts for title,
          // subtitle.
          // It already shows some leveling/hierarchy. Title and subtitle has different
          // font size, and they also have different color strength (title is stronger,
          // subtitle is a little gray/subtle). As well as the text used in leading and
          // trailing is different.
          style: style,
        );
      },
    );
  }
}
