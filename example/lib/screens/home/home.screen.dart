import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_report/easy_report.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/screens/forum/comment.test.screen.dart';
import 'package:example/screens/locale/locale.screen.dart';
import 'package:example/screens/forum/forum.screen.dart';
import 'package:example/screens/menu/menu.screen.dart';
import 'package:example/screens/messaging/messaging.screen.dart';
import 'package:example/screens/settings/settings.screen.dart';
import 'package:example/screens/storage/upload_image.screen.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          InkWell(
            child: MyDoc(
              builder: (user) => user == null
                  ? const AnonymousAvatar()
                  : UserAvatar(user: user),
            ),
            onTap: () => i.signedIn
                ? UserService.instance.showProfileUpdaeScreen(context)
                : context.push(SignInScreen.routeName),
          ),
          IconButton(
            onPressed: () {
              context.push(MenuScreen.routeName);
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('isSamllScreen: ${context.isSmallScreen}'),
            AuthStateChanges(
              builder: (user) => user == null
                  ? const Text('Sign-in first')
                  : Column(
                      children: [
                        ChatNewMessageCounter(builder: (no) {
                          return Stack(
                            children: [
                              UserAvatar.fromUid(uid: user.uid),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red.shade700,
                                  child: Text(
                                    '$no',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                        Text('User UID: ${user.uid}'),
                      ],
                    ),
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ChatService.instance.showChatRoomListScreen(context);
                  },
                  child: const Text("Chat Room List"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ChatService.instance.showChatRoomListScreen(context,
                        queryOption: ChatRoomListOption.receivedInvites);
                  },
                  child: const Text("Chat Invite List"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ChatService.instance.showOpenChatRoomListScreen(context);
                  },
                  child: const Text("Open Room List"),
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
                  onPressed: () async {
                    await UserService.instance.showUserSearchDialog(
                      context,
                      exactSearch: false,
                      itemBuilder: (user, index) => ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(user),
                        child: Text(user.displayName),
                      ),
                    );
                    // print('user; $user');
                  },
                  child:
                      const Text('User Search Dialog: partial search search'),
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
                ElevatedButton(
                  onPressed: () => showGeneralDialog(
                    context: context,
                    pageBuilder: (_, __, ___) => const ForumScreen(),
                  ),
                  child: const Text('Easy Forum Screen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) => const CommentTestScreen(),
                    );
                  },
                  child: const Text('Easy Comment Screen'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await confirm(
                      context: context,
                      title: const Text('title'),
                      subtitle: const CircleAvatar(
                        child: Text('yo'),
                      ),
                      message: const Text('message'),
                    );
                    // print('re; $re');
                  },
                  child: const Text(
                    'Confirm dialog',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => i.showBlockListScreen(context),
                  child: const Text(
                    'Block list',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ReportService.instance.showReportListScreen(context),
                  child: const Text(
                    'Report list',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      TaskService.instance.showTaskCreateScreen(context),
                  child: const Text('Task Crate'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      TaskService.instance.showTaskListScreen(context),
                  child: const Text('Task List of my creation'),
                ),
                ElevatedButton(
                    onPressed: () {
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (_, __, ___) {
                            return const SettingsScreen();
                          });
                    },
                    child: const Text('Setting')),
                ElevatedButton(
                  onPressed: () {
                    showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return const MessagingScreen();
                        });
                  },
                  child: const Text('Messaging'),
                ),
              ],
            ),
            //
            SizedBox(
              height: 180,
              child: UserListView(
                itemBuilder: (user, index) {
                  return Row(
                    children: [
                      UserAvatar(user: user),
                      Text('c: $index'),
                      TextButton(
                        onPressed: () =>
                            ChatService.instance.showChatRoomScreen(
                          context,
                          user: user,
                          // room: room,
                        ),
                        child: const Text('Chat'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await i.block(context: context, otherUid: user.uid);
                        },
                        child: UserBlocked(
                          otherUid: user.uid,
                          builder: (b) => Text(b ? 'Un-block' : 'Block'),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ReportService.instance.report(
                            context: context,
                            otherUid: user.uid,
                            documentReference: user.ref,
                          );
                        },
                        child: const Text('Report'),
                      ),
                      TextButton(
                        onPressed: () => i.showPublicProfileScreen(
                          context,
                          user: user,
                        ),
                        child: const Text('Public'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
