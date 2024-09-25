import 'package:example/screens/demo/comic/chat.tab.dart';
import 'package:example/screens/demo/comic/home.tab.dart';
import 'package:example/screens/demo/comic/profile.tab.dart';
import 'package:example/screens/demo/comic/settings.tab.dart';
import 'package:example/screens/demo/comic/status.dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ComicScreenDemoScreen extends StatefulWidget {
  const ComicScreenDemoScreen({super.key});

  @override
  State<ComicScreenDemoScreen> createState() => _ComicScreenDemoScreenState();
}

class _ComicScreenDemoScreenState extends State<ComicScreenDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int index = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: index == 0
              ? const Text('Home')
              : index == 1
                  ? const Text('Profile')
                  : index == 2
                      ? const Text('Chat')
                      : const Text('Settings'),
          bottom: index == 0
              ? TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Dashboard'),
                    Tab(text: 'Posts'),
                    Tab(text: 'News'),
                  ],
                )
              : null,
        ),
        body: index == 0
            ? HomeTab(tabController: _tabController)
            : index == 1
                ? const ProfileTab()
                : index == 2
                    ? const ChatTab()
                    : const SettingsTab(),
        endDrawer: NavigationDrawer(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Social Design System",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text("Comic Theme Demo"),
                  const SizedBox(height: 18),
                  const Icon(Icons.set_meal_outlined, size: 36),
                ],
              ),
            ),
            InkWell(
              onTap: () => _navigatiorButtonSetIndex(0),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Home'),
                ),
              ),
            ),
            InkWell(
              onTap: () => _navigatiorButtonSetIndex(1),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.person_outlined),
                  title: Text('Profile'),
                ),
              ),
            ),
            InkWell(
              onTap: () => _navigatiorButtonSetIndex(2),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.chat_bubble_outline),
                  title: Text('Chat'),
                ),
              ),
            ),
            InkWell(
              onTap: () => _navigatiorButtonSetIndex(3),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Setting'),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _navigatiorButtonSetIndex(null);
                // Open dialog
                showDialog(
                  context: context,
                  builder: (context) => Theme(
                    data: ComicTheme.of(context),
                    child: AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                          'Do you want to logout? (This is a demonstation only)'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => Theme(
                                data: ComicTheme.of(context),
                                child: AlertDialog(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Icon(
                                      Icons.set_meal_outlined,
                                      size: 36,
                                    ),
                                  ),
                                  title: const Text("Comic Theme"),
                                  content: const Text(
                                    "This is a demonstation only. Thank you for checking this out!",
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Logout'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text('Logout'),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) {
            if (v == index) return;
            setState(() {
              index = v;
            });
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: SizedBox(
                width: 48,
                height: 32,
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.chat_bubble_outline),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 14),
                        child: Badge(
                          label: Text(
                            '5',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              label: 'Chat',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
        floatingActionButton: index == 0
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const StatusDialog());
                },
                child: const Icon(Icons.add_reaction_outlined),
              )
            : null,
      ),
    );
  }

  _navigatiorButtonSetIndex(int? index) {
    Navigator.of(context).pop();
    if (index == null) return;
    setState(() {
      this.index = index;
    });
  }
}
