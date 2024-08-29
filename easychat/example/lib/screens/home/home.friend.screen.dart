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
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return const UserProfileUpdateScreen();
                    },
                  );
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
                onSelected: (String value) {
                  if (value == 'profile') {
                    // Navigator.of(context).pushNamed(UserProfileScreen.routeName);
                  } else if (value == 'signout') {
                    // UserSignOutService.instance.signOut();
                  } else if (value == 'find-friend') {
                    // Navigator.of(context).pushNamed(UserFindHomeFriendScreen.routeName);
                  }
                },
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
        const Text('@TODO: Display no of invitatations'),
        const Text('@TODO: top 3 invitations'),
        const Text(
            '@TODO: Display favorite friends: use easy_user_group pakcage'),
        const Text('@TODO: Display all 1:1 chats: hide the favorite friends'),
      ],
    );
  }
}
