import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class StatusDialog extends StatefulWidget {
  const StatusDialog({super.key});

  @override
  State<StatusDialog> createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  bool isHappy = false;
  bool isSad = false;
  bool isAngry = false;
  bool isTired = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("How are you today?"),
      content: Theme(
        data: SleekThemeData.of(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("What are you feeling from these emotions?"),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              children: [
                ChoiceChip(
                  selected: isHappy,
                  label: const Text("Happy"),
                  onSelected: (value) {
                    isHappy = value;
                    setState(() {});
                  },
                ),
                ChoiceChip(
                  selected: isSad,
                  label: const Text("Sad"),
                  onSelected: (value) {
                    isSad = value;
                    setState(() {});
                  },
                ),
                ChoiceChip(
                  selected: isAngry,
                  label: const Text("Angry"),
                  onSelected: (value) {
                    isAngry = value;
                    setState(() {});
                  },
                ),
                ChoiceChip(
                  selected: isTired,
                  label: const Text("Tired"),
                  onSelected: (value) {
                    isTired = value;
                    setState(() {});
                  },
                ),
                const ChoiceChip(
                  selected: false,
                  label: Text("Funny"),
                ),
                const ChoiceChip(
                  selected: true,
                  label: Text("Living"),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "What's on your mind?",
              ),
            ),
          ],
        ),
      ),
      actions: [
        Theme(
          data: SleekThemeData.of(context),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        )
      ],
    );
  }
}
