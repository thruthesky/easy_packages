import 'package:example/screens/app_bar/app_bar.screen.dart';
import 'package:example/screens/badge/badge.screen.dart';
import 'package:example/screens/bottom_app_bar/bottom_app_bar.screen.dart';
import 'package:example/screens/bottom_sheet/bottom_sheet.screen.dart';
import 'package:example/screens/buttons/buttons.screen.dart';
import 'package:example/screens/card/card.screen.dart';
import 'package:example/screens/checkbox/checkbox.screen.dart';
import 'package:example/screens/chip/chip.screen.dart';
import 'package:example/screens/demo/comic/comic.theme.screen.dart';
import 'package:example/screens/demo/login/sleek_login.demo.dart';
import 'package:example/screens/demo/sleek/sleek.theme.screen.dart';
import 'package:example/screens/dialog/dialog.screen.dart';
import 'package:example/screens/divider/divider.screen.dart';
import 'package:example/screens/dropdown/dropdown.screen.dart';
import 'package:example/screens/entry/basic_carousel_entry.screen.dart';
import 'package:example/screens/entry/round_carousel_entry.screen.dart';
import 'package:example/screens/entry/wave_carousel_entry.screen.dart';
import 'package:example/screens/floating_action_button/floating_action_button.screen.dart';
import 'package:example/screens/icon_buttons/icon_buttons.screen.dart';
import 'package:example/screens/list_tile/list_tile.screen.dart';
import 'package:example/screens/demo/login/comic_login.demo.dart';
import 'package:example/screens/list_view/comic.list_view.screen.dart';
import 'package:example/screens/list_view/sleek.list_view.screen.dart';
import 'package:example/screens/navigation_bar/navigation_bar.screen.dart';
import 'package:example/screens/navigation_drawer/navigation_drawer.screen.dart';
import 'package:example/screens/navigation_rail.dart/navigation_rail.screen.dart';
import 'package:example/screens/birthdate_picker/birthdate.picker.screen.dart';
import 'package:example/screens/progress_indicator/progress_indicator.screen.dart';
import 'package:example/screens/segmented_button/segmented_button.dart';
import 'package:example/screens/setting/setting.screen.dart';
import 'package:example/screens/sleep_walker/sleep_walker.screen.dart';
import 'package:example/screens/snackbar/snackbars.screen.dart';
import 'package:example/screens/tab_bar/tab_bar.screen.dart';
import 'package:example/screens/text_field/text_field.screen.dart';
import 'package:example/screens/text_form_field/text_form_field.screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search_screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<SearchItem> _items = [
    const SearchItem(name: 'Sleek Login', screen: SleekLoginDemo()),
    const SearchItem(name: 'Comic Login', screen: ComicLoginDemo()),
    const SearchItem(name: 'Comic Theme', screen: ComicScreenDemoScreen()),
    const SearchItem(name: 'Sleek Theme ', screen: SleekScreenDemoScreen()),

    const SearchItem(name: "AppBar", screen: AppBarScreen()),
    const SearchItem(name: 'Badge', screen: BadgeScreen()),
    const SearchItem(name: 'BirthdayPicker', screen: BirthdatePickerScreen()),
    const SearchItem(name: 'BottomAppBar', screen: BottomAppBarScreen()),
    const SearchItem(name: 'BottomSheet', screen: BottomSheetScreen()),
    const SearchItem(name: 'Buttons', screen: ButtonsScreen()),
    const SearchItem(name: 'Card', screen: CardScreen()),
    const SearchItem(name: 'Checkbox', screen: CheckboxScreen()),

    // const SearchItem(
    //     name: 'CheckboxListTile', screen: CheckboxListTileScreen()),
    const SearchItem(name: 'Chip', screen: ChipScreen()),
    const SearchItem(name: 'Dropdown', screen: DropdownScreen()),
    const SearchItem(name: 'Dialog', screen: DialogScreen()),
    const SearchItem(name: 'Divider', screen: DividerScreen()),
    const SearchItem(name: 'Floating Action Button', screen: FloatingActionButtonScreen()),
    const SearchItem(name: 'IconButton', screen: IconButtonScreen()),
    const SearchItem(name: 'ListTile', screen: ListTileScreen()),
    const SearchItem(name: 'Login Screen', screen: ComicLoginDemo()),
    const SearchItem(name: 'NavigationBar', screen: NavigationBarScreen()),
    const SearchItem(name: "NavigationDrawer", screen: NavigationDrawerScreen()),
    const SearchItem(name: 'NavigationRail', screen: NavigationRailScreen()),
    const SearchItem(name: 'Progress Indicator', screen: ProgressIndicatorScreen()),
    const SearchItem(name: 'Segmented Button', screen: SegmentedButtonScreen()),
    const SearchItem(name: 'SnackBar', screen: SnackBarScreen()),
    const SearchItem(name: 'TabBar', screen: TabBarScreen()),
    const SearchItem(name: 'TextFields', screen: TextFieldScreen()),
    const SearchItem(name: 'TextFormField', screen: TextFormFieldScreen()),
    const SearchItem(name: 'ComicListView', screen: ComicListViewScreen()),
    const SearchItem(name: 'SleekListView', screen: SleekListViewScreen()),
    const SearchItem(name: 'Setting', screen: SettingScreen()),
    const SearchItem(name: 'Basic Carousel Entry', screen: BasicCarouselEntryScreen()),
    const SearchItem(name: 'Wave Carousel Entry', screen: WaveCarouselEntryScreen()),
    const SearchItem(name: 'Round Carousel Entry', screen: RoundCarouselEntryScreen()),
    const SearchItem(name: 'Sleep Walker', screen: SleepWalkerScreen()),
    const SearchItem(name: 'Color scheme', screen: CurrentThemeScreen()),
  ];

  List<SearchItem> _result = [];
  final TextEditingController _searchController = TextEditingController();

  void _searchWidgets(String query) {
    final results = _items.where((widget) {
      final widgetName = widget.name.toLowerCase().trim().replaceAll(' ', '');
      final input = query.toLowerCase().trim().replaceAll(' ', '');
      return widgetName.contains(input);
    }).toList();

    setState(() {
      _result = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _result = _items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Widgets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ComicTheme(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search widgets...',
                ),
                onChanged: _searchWidgets,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _result.length,
                    itemBuilder: (context, index) {
                      final widget = _result[index];
                      return ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => widget.screen),
                        ),
                        child: Text(widget.name),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}

class SearchItem {
  final String name;
  final Widget screen;
  // final String description;
  const SearchItem({
    required this.name,
    required this.screen,
    // required this.description,
  });
}
