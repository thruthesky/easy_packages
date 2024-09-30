import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easy_report/easy_report.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/screens/firebase_database_list_view/firebase_database_list_view.screen.dart';
import 'package:example/screens/locale/locale.screen.dart';
import 'package:example/screens/forum/forum.screen.dart';
import 'package:example/screens/menu/menu.screen.dart';
import 'package:example/screens/messaging/messaging.screen.dart';
import 'package:example/screens/settings/settings.screen.dart';
import 'package:example/screens/storage/upload_image.screen.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_locale/easy_locale.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool add = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      test();
    });
  }

  test() async {
    final room = await ChatRoom.get('-O7fycrHFwAQsR4bJuRa');
    if (!mounted) return;
    ChatService.instance.showChatRoomScreen(
      context,
      room: room,
    );
  }

  @override
  Widget build(BuildContext context) {
    lo.merge({
      'version': {'en': 'V', 'ko': '버'}
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          InkWell(
            child: MyDoc(
              builder: (user) => user == null
                  ? const AnonymousAvatar()
                  : UserAvatar(
                      photoUrl: user.photoUrl,
                      initials: (user.displayName).or((user.name).or(user.uid)),
                    ),
            ),
            onTap: () => i.signedIn
                ? UserService.instance.showProfileUpdateScreen(context)
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
            SizedBox(
                height: 150,
                child: ListView(
                  children: [
                    if (add)
                      Row(
                        children: [
                          UserAvatar.fromUid(uid: 'L4iIrNu5SoWmvLXqFpCxSvwjQvq1'),
                          const SizedBox(width: 8),
                          const Text('UserAvatar.fromUid(uid: "L4i...")'),
                        ],
                      ),
                    Row(
                      children: [
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: ThumbnailImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/withcenter-test-4.appspot.com/o/users%2FShl6IN3nQAgqxFx5WKB4SF8lKzu1%2Fimage_picker_1D095BF3-3009-4D8E-89A7-C7EF11586BF3-26365-00000036F821F7EC.jpg?alt=media&token=7456aca2-f889-48a1-acc3-92db5f458dc8',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          color: Colors.blue,
                          height: 50,
                          width: 50,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/withcenter-test-4.appspot.com/o/users%2FShl6IN3nQAgqxFx5WKB4SF8lKzu1%2Fimage_picker_1D095BF3-3009-4D8E-89A7-C7EF11586BF3-26365-00000036F821F7EC.jpg?alt=media&token=7456aca2-f889-48a1-acc3-92db5f458dc8',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: UserAvatar.fromUid(uid: 'Shl6IN3nQAgqxFx5WKB4SF8lKzu1'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        UserAvatar.fromUid(uid: 'ugQbQbZ1ilVkc9OlLX3OozgoX8G3'),
                        const SizedBox(width: 8),
                        const Text('UserAvatar.fromUid(uid: "ugQbQ...")'),
                      ],
                    ),
                    UserAvatar.fromUid(uid: 't9zv6Y8JCEM5qcEjUEe2DqZrxI43'),
                    UserAvatar.fromUid(uid: 'ohSJSLwJkfhcgCNMdbQmCnqQNpG2'),
                    UserAvatar.fromUid(uid: 'mFHhhZA5rgX9lPQVINmTyQcmZ822'),
                    UserAvatar.fromUid(uid: 'irvnReNOlVVCaLSsSCw5mRsenlC2'),
                    UserAvatar.fromUid(uid: 'iAqhcyZuMigpgqUkRvTaSvSShe02'),
                    UserAvatar.fromUid(uid: 'dDFHbEVOiOV8cQ2YADytcSHJQ513'),
                  ],
                )),

            Container(
                padding: const EdgeInsets.all(24),
                height: 150,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: ThumbnailImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/withcenter-test-4.appspot.com/o/users%2FShl6IN3nQAgqxFx5WKB4SF8lKzu1%2Fimage_picker_1D095BF3-3009-4D8E-89A7-C7EF11586BF3-26365-00000036F821F7EC.jpg?alt=media&token=7456aca2-f889-48a1-acc3-92db5f458dc8',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: UserAvatar.fromUid(uid: 'Shl6IN3nQAgqxFx5WKB4SF8lKzu1'),
                        )
                      ],
                    ),
                  ],
                )),

            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('setState')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    add = !add;
                  });
                },
                child: const Text('add')),
            Row(
              children: [
                Text('version'.t),
                Text('   isSamllScreen: ${context.isSmallScreen}'),
              ],
            ),
            AuthStateChanges(
              builder: (user) => user == null
                  ? const Text('Sign-in first')
                  : Column(
                      children: [
                        // ChatNewMessageCounter(builder: (no) {
                        //   return Stack(
                        //     children: [
                        //       UserAvatar.fromUid(uid: user.uid),
                        //       Positioned(
                        //         right: 0,
                        //         top: 0,
                        //         child: CircleAvatar(
                        //           radius: 12,
                        //           backgroundColor: Colors.red.shade700,
                        //           child: Text(
                        //             '$no',
                        //             style: const TextStyle(
                        //               fontSize: 10,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   );
                        // }),
                        Text('User UID: ${user.uid}'),
                        ChatInvitationCount(
                          builder: (count) => Text('Invitation Count: $count'),
                        ),
                      ],
                    ),
            ),
            Value(
              ref: FirebaseDatabase.instance.ref('tmp/a'),
              builder: (v, r) => TextButton(
                child: Text('Value: $v'),
                onPressed: () => r.set(
                  'Time : ${DateTime.now()}',
                ),
              ),
            ),
            Value(
              sync: false,
              ref: FirebaseDatabase.instance.ref('tmp/a'),
              builder: (v, r) => TextButton(
                child: Text('Value: $v'),
                onPressed: () => r.set(
                  'Time : ${DateTime.now()}',
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(4, 0, 4, 0)),
                ),
              ),
              child: Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ChatService.instance.showChatRoomListScreen(context);
                    },
                    child: const Text("My Chat Join List"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ChatService.instance.showInviteListScreen(
                        context,
                      );
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
                    onPressed: () async {
                      final user = await UserService.instance.showSearchDialog(
                        context,
                        exactSearch: true,
                      );
                      if (user != null) {
                        if (context.mounted) {
                          UserService.instance.showPublicProfileScreen(context, user: user);
                        }
                      }
                    },
                    child: const Text('User Search Dialog: exact search'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await UserService.instance.showSearchDialog(
                        context,
                        exactSearch: false,
                        itemBuilder: (user, index) => ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(user),
                          child: Text(user.displayName),
                        ),
                      );
                      // print('user; $user');
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
                  ElevatedButton(
                    onPressed: () => showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) => const ForumScreen(),
                    ),
                    child: const Text('Easy Forum Screen'),
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
                    onPressed: () => ReportService.instance.showReportListScreen(context),
                    child: const Text(
                      'Report list',
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () => TaskService.instance.showTaskCreateScreen(context),
                  //   child: const Text('Task Crate'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => TaskService.instance.showTaskListScreen(context),
                  //   child: const Text('Task List of my creation'),
                  // ),
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     UserGroupService.instance.showUserGroupListScreen(context);
                  //   },
                  //   child: const Text('User Group'),
                  // ),

                  ElevatedButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return const FirebaseDatabaseListViewScreen();
                        },
                      );
                    },
                    child: const Text('FirebaseDatabaseListView'),
                  ),
                ],
              ),
            ),
            //
            // SizedBox(
            //   height: 180,
            //   child: UserListView(
            //     itemBuilder: (user, index) {
            //       return Row(
            //         children: [
            //           UserAvatar(
            //             photoUrl: user.photoUrl,
            //             initials: (user.displayName).or((user.name).or(user.uid)),
            //           ),
            //           Text('c: $index'),
            //           TextButton(
            //             onPressed: () => ChatService.instance.showChatRoomScreen(
            //               context,
            //               user: user,
            //               // room: room,
            //             ),
            //             child: const Text('Chat'),
            //           ),
            //           TextButton(
            //             onPressed: () async {
            //               await i.block(context: context, otherUid: user.uid);
            //             },
            //             child: UserBlocked(
            //               otherUid: user.uid,
            //               builder: (b) => Text(b ? 'Un-block' : 'Block'),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () async {
            //               await ReportService.instance.report(
            //                 context: context,
            //                 reportee: user.uid,
            //                 path: user.ref.path,
            //                 type: 'user',
            //                 summary: 'Reporting: ${user.displayName}, uid: ${user.uid}',
            //               );
            //             },
            //             child: const Text('Report'),
            //           ),
            //           TextButton(
            //             onPressed: () => i.showPublicProfileScreen(
            //               context,
            //               user: user,
            //             ),
            //             child: const Text('Public'),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
