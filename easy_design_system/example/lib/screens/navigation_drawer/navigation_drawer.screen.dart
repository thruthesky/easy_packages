import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class NavigationDrawerScreen extends StatefulWidget {
  static const String routeName = '/navigation_drawer';
  const NavigationDrawerScreen({super.key});

  @override
  State<NavigationDrawerScreen> createState() => _NavigationDrawerScreenState();
}

class _NavigationDrawerScreenState extends State<NavigationDrawerScreen> {
  int _selectedDestination = 0;
  String selectedTheme = 'Comic';

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Naviagtion Drawer"),
          actions: const [],
        ),
        drawer: Theme(
          data: ComicTheme.of(context),
          child: NavigationDrawer(
            onDestinationSelected: selectDestination,
            selectedIndex: _selectedDestination,
            children: const [
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Drawer"),
                  ),
                ),
              ),
              NavigationDrawerDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationDrawerDestination(
                  icon: Icon(Icons.message), label: Text('Chat')),
              NavigationDrawerDestination(
                  icon: Icon(Icons.person), label: Text('Profile'))
            ],
          ),
        ),
        endDrawer: Theme(
          data: selectedTheme == 'Comic'
              ? ComicTheme.of(context)
              : SleekTheme.of(context),
          child: NavigationDrawer(
            onDestinationSelected: selectDestination,
            selectedIndex: _selectedDestination,
            children: const [
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("End Drawer"),
                  ),
                ),
              ),
              NavigationDrawerDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationDrawerDestination(
                  icon: Icon(Icons.message), label: Text('Chat')),
              NavigationDrawerDestination(
                  icon: Icon(Icons.person), label: Text('Profile'))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Table(
                children: [
                  const TableRow(
                    children: [
                      Center(child: Text('Comic Theme')),
                      Center(child: Text('Sleek Theme')),
                    ],
                  ),
                  TableRow(
                    children: [
                      Builder(builder: (context) {
                        return Column(
                          children: [
                            ElevatedButton(
                              child: const Text('Open Drawer'),
                              onPressed: () {
                                setState(() {
                                  selectedTheme = 'Comic';
                                });
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                            ElevatedButton(
                                child: const Text(' Open End Drawer'),
                                onPressed: () {
                                  setState(() {
                                    selectedTheme = 'Comic';
                                  });
                                  Scaffold.of(context).openEndDrawer();
                                }),
                          ],
                        );
                      }),
                      Builder(builder: (context) {
                        return Column(
                          children: [
                            ElevatedButton(
                              child: const Text('Open Drawer'),
                              onPressed: () {
                                setState(() {
                                  selectedTheme = 'Sleek';
                                });
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                            ElevatedButton(
                                child: const Text(' Open End Drawer'),
                                onPressed: () {
                                  setState(() {
                                    selectedTheme = 'Sleek';
                                  });
                                  Scaffold.of(context).openEndDrawer();
                                }),
                          ],
                        );
                      })
                    ],
                  ),
                ],
              ),
              const NothingToLearn()
            ],
          ),
        ));
    // return Column(
    //   children: [
    //     ElevatedButton(
    //       child: const Text('Comic Navigation Drawer'),
    //       onPressed: () => Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (_) => const ComicNavigationDrawerScreen(),
    //         ),
    //       ),
    //     ),
    //     ElevatedButton(
    //       child: const Text('Sleek Navigation Drawer '),
    //       onPressed: () => Navigator.of(context).push(MaterialPageRoute(
    //         builder: (_) => const SleekNavigationDrawerScreen(),
    //       )),
    //     ),
    //   ],
    // );
  }
}
