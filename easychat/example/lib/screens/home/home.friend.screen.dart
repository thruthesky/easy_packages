import 'package:easychat/easychat.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

class HomeFriendScreen extends StatefulWidget {
  static const String routeName = '/Friend';
  const HomeFriendScreen({super.key});

  @override
  State<HomeFriendScreen> createState() => _HomeFriendScreenState();
}

class _HomeFriendScreenState extends State<HomeFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Row(
            children: [
              const Text("Friend"),
              const Spacer(),
              IconButton(
                onPressed: () {
                  if (UserService.instance.signedIn) {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return const UserProfileUpdateScreen();
                      },
                    );
                  } else {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return const SignInScreen();
                      },
                    );
                  }
                },
                icon: const Icon(Icons.manage_accounts),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Text("Profile"),
                    ),
                    const PopupMenuItem(
                      value: 'find-friend',
                      child: Text("Find friend"),
                    ),
                    const PopupMenuItem(
                      value: 'signout',
                      child: Text("Sign Out"),
                    ),
                  ];
                },
                onSelected: (String value) async {
                  if (value == 'profile') {
                    // Navigator.of(context).pushNamed(UserProfileScreen.routeName);
                  } else if (value == 'signout') {
                    UserService.instance.signOut();
                  } else if (value == 'find-friend') {
                    final user =
                        await UserService.instance.showSearchDialog(context);
                    if (user != null) {
                      if (context.mounted) {
                        ChatService.instance.showChatRoomScreen(
                          context,
                          user: user,
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
        Text('my uid: $myUid'),
        const Divider(),
        Wrap(
          children: [
            TextButton(
              onPressed: () => ChatTestService.instance.invitationNotSent(
                'jp38SPAWRDUfbHoVbIZhY1fJTDM2',
              ),
              child: const Text('TEST invitationNotSent'),
            ),
            TextButton(
              onPressed: () async {
                await ChatTestService.instance.createGroupChat();
              },
              child: const Text('createGroupChat'),
            ),
            TextButton(
              onPressed: () async {
                await ChatTestService.instance.joinGroupChat();
              },
              child: const Text('joinGroupChat'),
            ),
            TextButton(
              onPressed: () async {
                await ChatTestService.instance.joinOpenChat();
              },
              child: const Text('joinOpenChat'),
            )
          ],
        ),
        Expanded(
          child: AuthStateChanges(builder: (user) {
            if (user == null) {
              return const Center(
                child: Text('Sign in to see your friends'),
              );
            }
            return ChatRoomListView(
              headerBuilder: () {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
