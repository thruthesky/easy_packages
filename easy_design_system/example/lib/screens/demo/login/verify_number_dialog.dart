import 'package:flutter/material.dart';

class VerifyNumberDialog extends StatelessWidget {
  const VerifyNumberDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'OTP Verification',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Enter the OTP sent to +639012345678',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          const TextField(
            decoration: InputDecoration(
                hintText: 'OTP',
                label: Text('OTP'),
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Didn't receive OTP? ",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              TextButton(onPressed: () {}, child: const Text('Resend'))
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    margin: const EdgeInsets.all(24),
                    behavior: SnackBarBehavior.floating,
                    content: const Text('OTP Verified'),
                    action: SnackBarAction(
                      onPressed: () {},
                      label: 'Action',
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Vertfy & Continue'),
            ),
          )
        ],
      ),
    );
  }
}
