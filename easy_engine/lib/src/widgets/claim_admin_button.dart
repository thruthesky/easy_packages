import 'package:easy_engine/src/easy_engine.defines.dart';
import 'package:flutter/material.dart';

class ClaimAdminButton extends StatelessWidget {
  const ClaimAdminButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await engine.claimAdmin();
      },
      child: const Text('Claim Admin'),
    );
  }
}
