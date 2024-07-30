import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Report dialog
class ReportDialog extends StatelessWidget {
  const ReportDialog({
    super.key,
    required this.reportee,
    required this.documentReference,
  });

  final String reportee;
  final DocumentReference documentReference;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 0),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Why are you reporting this user?'.t,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            UserDoc(
                uid: reportee,
                builder: (user) {
                  if (user == null) {
                    return Text('User not found'.t);
                  }
                  return Column(
                    children: [
                      UserAvatar(user: user),
                      const SizedBox(height: 8),
                      Text(user.displayName),
                    ],
                  );
                }),
            const SizedBox(height: 24),
            Text(
              'Select a reason for reporting'.t,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop('spam'),
                  child: Text('Spam'.t),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop('abusive'),
                  child: Text('Abusive'.t),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop('other'),
                  child: Text('Other'.t),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
