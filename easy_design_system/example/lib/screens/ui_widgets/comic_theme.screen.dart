import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ComicThemeUiWidgetsScreen extends StatefulWidget {
  static const String routeName = '/ComicThemeUiWidgets';
  const ComicThemeUiWidgetsScreen({super.key});

  @override
  State<ComicThemeUiWidgetsScreen> createState() => _ComicThemeUiWidgetsScreenState();
}

class _ComicThemeUiWidgetsScreenState extends State<ComicThemeUiWidgetsScreen> with TickerProviderStateMixin {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  final TextEditingController menuController = TextEditingController();
  late TabController _tabController;
  late AnimationController _animationController;

  int selectedIndex = 0;
  int navigationBarIndex = 0;
  int tabBarIndex = 0;
  bool isSelected = false;

  List<String> list = <String>['One', 'Two', 'Three', 'Four'];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Set<String> _selected = {'value1'};

  void updateSelection(Set<String> newSelection) {
    setState(() {
      _selected = newSelection;
    });
  }

  void changeValue(bool? value) {
    setState(() {
      isSelected = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ComicTheme(
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Comic'),
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) => setState(() {
              tabBarIndex = index;
            }),
            tabs: const [
              Tab(text: 'Widgets'),
              Tab(text: 'Scaffold'),
              Tab(text: 'Modals'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            /// Widgets
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Elevated Button'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined Button'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: changeValue,
                        ),
                        const Text('Checkbox'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          groupValue: true,
                          value: isSelected,
                          onChanged: changeValue,
                        ),
                        const Text('Radio Button'),
                      ],
                    ),
                    Switch(value: isSelected, onChanged: changeValue),
                    ChoiceChip(
                      selected: isSelected,
                      label: const Text('Chip'),
                      onSelected: changeValue,
                    ),
                    InputChip(
                      selected: isSelected,
                      label: const Text('Input Chip'),
                      onSelected: changeValue,
                    ),
                    Theme(
                      data: ComicIconButtonThemeData.of(context),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                    ),
                    SegmentedButton(
                      selected: _selected,
                      segments: const [
                        ButtonSegment(value: 'value1', label: Text('Inbox')),
                        ButtonSegment(value: 'value2', label: Text('Primary')),
                        ButtonSegment(value: 'value3', label: Text('Others')),
                      ],
                      onSelectionChanged: updateSelection,
                    ),
                    DropdownMenu<String>(
                      initialSelection: 'One',
                      controller: menuController,
                      label: const Text('Dropdown Menu'),
                      onSelected: (String? v) {},
                      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String v) {
                        return DropdownMenuEntry<String>(
                          value: v,
                          label: v,
                          enabled: v != 'Four',
                        );
                      }).toList(),
                    ),
                    const ListTile(
                      leading: Icon(Icons.sailing),
                      title: Text('ListTile'),
                      trailing: Badge(
                        label: Text('5'),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('TextField'),
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        label: Text('TextFormField'),
                      ),
                    ),
                    const LinearProgressIndicator(),
                    const CircularProgressIndicator(),
                    const Divider(),
                  ],
                ),
              ),
            ),

            /// Scaffold Based Widgets
            Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () {},
                ),
                title: const Text('Comic AppBar'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        NavigationRail(
                          onDestinationSelected: _onItemTapped,
                          destinations: const [
                            NavigationRailDestination(
                              icon: Icon(Icons.home),
                              label: Text('Home'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.message),
                              label: Text('Chat'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.person),
                              label: Text('Profile'),
                            ),
                          ],
                          selectedIndex: selectedIndex,
                        ),
                        const VerticalDivider(
                          width: 0,
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Card(
                              child: SizedBox(
                                height: 200,
                                child: Center(child: Text('This is a card')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomAppBar(
                    child: Row(
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_up)),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: navigationBarIndex,
                onDestinationSelected: (int index) => setState(() {
                  navigationBarIndex = index;
                }),
                destinations: const <Widget>[
                  NavigationDestination(
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

            /// Modals
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  OutlinedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ComicTheme(
                        child: AlertDialog(
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                const Expanded(
                                  child: Text('This is a sample Dialog'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('Dialog'),
                  ),
                  OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('This is a Snackbar'),
                        action: SnackBarAction(label: 'Close', onPressed: () => Navigator.of(context).pop()),
                      ),
                    ),
                    child: const Text('SnackBar'),
                  ),
                  OutlinedButton(
                    onPressed: () => _scaffoldState.currentState?.showBottomSheet(
                      (context) => BottomSheet(
                        animationController: _animationController,
                        onClosing: () {},
                        builder: (context) => SizedBox(
                          height: 300,
                          child: Center(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close BottomSheet'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('BottomSheet'),
                  ),
                  OutlinedButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => ComicTheme(
                        child: BottomSheet(
                          animationController: _animationController,
                          enableDrag: false,
                          onClosing: () {},
                          builder: (context) => const SizedBox(
                            height: 300,
                            child: Center(child: Text('Modal BottomSheet')),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('Modal BottomSheet'),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: tabBarIndex == 0
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              )
            : null,
        drawer: const MyDrawer(),
        endDrawer: const MyDrawer(),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedDestination = 0;

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
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
        NavigationDrawerDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationDrawerDestination(icon: Icon(Icons.message), label: Text('Chat')),
        NavigationDrawerDestination(icon: Icon(Icons.person), label: Text('Profile'))
      ],
    );
  }
}
