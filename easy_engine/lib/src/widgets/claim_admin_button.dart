import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_engine/src/engine.defines.dart';
import 'package:flutter/material.dart';

/// Claim Admin Button
///
/// A button to claim a user as an admin.
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
        try {
          await engine.claimAdmin(region: region);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Sucess: You have claimed yourself as admin. You are an admin now.'),
              ),
            );
          }
        } on FirebaseFunctionsException catch (e) {
          if (context.mounted) {
            onFailure(context, '${e.code}/${e.message}');
          }
        } catch (e) {
          if (context.mounted) {
            onFailure(context, e.toString());
          }
        }
      },
      child: const Text('Claim Admin'),
    );
  }

  onFailure(BuildContext context, String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}
