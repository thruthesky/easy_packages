import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_engine/easy_engine.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/screens/locale/locale.screen.dart';
import 'package:example/screens/storage/upload_image.screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'age'.t,
            ),
            AuthStateChanges(
              builder: (user) {
                return user == null
                    ? const EmailPasswordLogin()
                    : Column(
                        children: [
                          Text('User UID: ${user.uid}'),
                          ElevatedButton(
                            onPressed: () => UserService.instance
                                .showProfileUpdaeScreen(context),
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
                                print(re);
                              } on FirebaseFunctionsException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error: ${e.code}/${e.message}'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Delete Account'),
                          ),
                        ],
                      );
              },
            ),
            ElevatedButton(
              onPressed: () {
                UserService.instance.showUserSearchDialog(
                  context,
                  exactSearch: true,
                );
              },
              child: const Text('User Search Dialog: exact search'),
            ),
            ElevatedButton(
              onPressed: () {
                UserService.instance.showUserSearchDialog(
                  context,
                  exactSearch: false,
                );
              },
              child: const Text('User Search Dialog: partial search search'),
            ),
            ElevatedButton(
              onPressed: () {
                ChatService.instance.showChatRoomListScreen(context);
              },
              child: const Text('Chat Room List Screen'),
            ),
            ElevatedButton(
              onPressed: () => showGeneralDialog(
                context: context,
                pageBuilder: (_, __, ___) => const UploadImageScreen(),
              ),
              child: const Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () => showGeneralDialog(
                context: context,
                pageBuilder: (_, __, ___) => const LocaleScreen(),
              ),
              child: const Text('Easy Locale Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
