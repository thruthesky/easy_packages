import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  NavigationBarScreenState createState() => NavigationBarScreenState();
}

class NavigationBarScreenState extends State<NavigationBarScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigation Bar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Comic Theme"),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: Scaffold(
                  bottomNavigationBar: Theme(
                    data: ComicTheme.of(context),
                    child: NavigationBar(
                      onDestinationSelected: (int index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      // indicatorColor: Colors.amber,
                      selectedIndex: currentPageIndex,
                      destinations: const <Widget>[
                        NavigationDestination(
                          // selectedIcon: Icon(Icons.home),
                          // icon: Icon(Icons.home_outlined),
                          // selectedIcon: Icon(Icons.home),
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Badge(child: Icon(Icons.notifications_sharp)),
                          label: 'Notifications',
                        ),
                        NavigationDestination(
                          icon: Badge(
                            label: Text('2'),
                            child: Icon(Icons.messenger_sharp),
                          ),
                          label: 'Messages',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text("Sleek Theme"),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: Scaffold(
                  bottomNavigationBar: Theme(
                    data: SleekTheme.of(context),
                    child: NavigationBar(
                      onDestinationSelected: (int index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      // indicatorColor: Colors.amber,
                      selectedIndex: currentPageIndex,
                      destinations: const <Widget>[
                        NavigationDestination(
                          // selectedIcon: Icon(Icons.home),
                          // icon: Icon(Icons.home_outlined),
                          // selectedIcon: Icon(Icons.home),
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Badge(child: Icon(Icons.notifications_sharp)),
                          label: 'Notifications',
                        ),
                        NavigationDestination(
                          icon: Badge(
                            label: Text('2'),
                            child: Icon(Icons.messenger_sharp),
                          ),
                          label: 'Messages',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const NothingToLearn(),
            ],
          ),
        ),
      ),
    );
  }
}
