import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  TabBarScreenState createState() => TabBarScreenState();
}

class TabBarScreenState extends State<TabBarScreen>
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBarScreen'),
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(text: 'Widgets'),
        //     Tab(text: 'Theme'),
        //     Tab(text: 'Color Scheme'),
        //   ],
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Comic"),
            SizedBox(
              height: 100,
              width: double.maxFinite,
              child: Theme(
                data: ComicTheme.of(context),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 0,
                    bottom: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Widgets'),
                        Tab(text: 'Theme'),
                        Tab(text: 'Color Scheme'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Text("Sleek"),
            SizedBox(
              height: 100,
              width: double.maxFinite,
              child: Theme(
                data: SleekTheme.of(context),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 0,
                    bottom: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Widgets'),
                        Tab(text: 'Theme'),
                        Tab(text: 'Color Scheme'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const NothingToLearn(),
          ],
        ),
      ),
    );
  }
}
