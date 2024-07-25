import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_engine/easy_engine.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/Menu';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Column(
        children: [
          const Text("Menu"),
          ElevatedButton(
            onPressed: () =>
                UserService.instance.showProfileUpdaeScreen(context),
            child: const Text('Profile update'),
          ),
          ElevatedButton(
            onPressed: () => i.signOut(),
            child: const Text('Sign out'),
          ),
          const ClaimAdminButton(region: 'asia-northeast3'),
          ElevatedButton(
            onPressed: () async {
              try {
                final re = await engine.deleteAccount();
                debugPrint(re);
              } on FirebaseFunctionsException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.code}/${e.message}'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                    ),
                  );
                }
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
