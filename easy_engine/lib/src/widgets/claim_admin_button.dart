import 'package:easy_engine/src/easy_engine.defines.dart';
import 'package:flutter/material.dart';

class ClaimAdminButton extends StatelessWidget {
  const ClaimAdminButton({
    super.key,
    this.region,
  });

  final String? region;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await engine.claimAdmin(region: region);
      },
      child: const Text('Claim Admin'),
    );
  }
}
