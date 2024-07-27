import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key, required this.documentReference});

  final DocumentReference documentReference;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
          Text(
            'Why are you reporting this?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Select a reason for reporting.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop('spam'),
                child: const Text('Spam'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop('abusive'),
                child: const Text('Abusive'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop('other'),
                child: const Text('Other'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
