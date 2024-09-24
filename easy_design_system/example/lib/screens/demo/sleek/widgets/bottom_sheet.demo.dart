import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class BottomSheetDemo extends StatelessWidget {
  const BottomSheetDemo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => Theme(
          data: SleekTheme.of(context),
          child: BottomSheet(
            onClosing: () {},
            builder: (context) {
              return SizedBox(
                height: 250,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "There is no secret to success except hard work and getting something indefinable which we call 'the breaks.' In order for a writer to succeed, I suggest three things - read and write - and wait.",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "- Countee Cullen",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Thank You!"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      child: const Text(
        'Want to learn a secret?',
      ),
    );
  }
}
