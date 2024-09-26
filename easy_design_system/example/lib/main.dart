import 'package:example/app.state.dart';
import 'package:example/contents/comic_border.content.dart';
import 'package:example/contents/comic_icon_button_theme_data.content.dart';
import 'package:example/contents/comic_text_button_theme_data.content.dart';
import 'package:example/contents/home.content.dart';
import 'package:example/contents/sleek_icon_button_theme_data.content.dart';
import 'package:example/screens/color_scheme/color_scheme.screen.dart';
import 'package:easy_design_system/easy_design_system.dart';
import 'package:example/screens/demo/sleek/sleek.theme.screen.dart';
import 'package:example/screens/demo/login/sleek_login.demo.dart';
import 'package:example/screens/dialog/dialog.screen.dart';
import 'package:example/screens/app_bar/app_bar.screen.dart';
import 'package:example/screens/badge/badge.screen.dart';
import 'package:example/screens/bottom_app_bar/bottom_app_bar.screen.dart';
import 'package:example/screens/bottom_sheet/bottom_sheet.screen.dart';
import 'package:example/screens/buttons/buttons.screen.dart';
import 'package:example/screens/card/card.screen.dart';
import 'package:example/screens/checkbox/checkbox.screen.dart';
import 'package:example/screens/chip/chip.screen.dart';
import 'package:example/screens/demo/comic/comic.theme.screen.dart';
import 'package:example/screens/divider/divider.screen.dart';
import 'package:example/screens/dropdown/dropdown.screen.dart';
import 'package:example/screens/floating_action_button/floating_action_button.screen.dart';
import 'package:example/screens/icon_buttons/icon_buttons.screen.dart';
import 'package:example/screens/list_tile/list_tile.screen.dart';
import 'package:example/screens/entry/basic_carousel_entry.screen.dart';
import 'package:example/screens/entry/round_carousel_entry.screen.dart';
import 'package:example/screens/entry/wave_carousel_entry.screen.dart';
import 'package:example/screens/demo/login/comic_login.demo.dart';
import 'package:example/screens/list_view/comic.list_view.screen.dart';
import 'package:example/screens/list_view/sleek.list_view.screen.dart';
import 'package:example/screens/navigation_drawer/navigation_drawer.screen.dart';
import 'package:example/screens/navigation_bar/navigation_bar.screen.dart';
import 'package:example/screens/navigation_rail.dart/navigation_rail.screen.dart';
import 'package:example/screens/birthdate_picker/birthdate.picker.screen.dart';
import 'package:example/screens/progress_indicator/progress_indicator.screen.dart';
import 'package:example/screens/radio_button/radio_button.dart';
import 'package:example/screens/search/search.screen.dart';
import 'package:example/screens/segmented_button/segmented_button.dart';
import 'package:example/screens/setting/setting.screen.dart';
import 'package:example/screens/sleep_walker/sleep_walker.screen.dart';
import 'package:example/screens/snackbar/snackbars.screen.dart';
import 'package:example/screens/switch/switch.dart';
import 'package:example/screens/tab_bar/tab_bar.screen.dart';
import 'package:example/screens/text_field/text_field.screen.dart';
import 'package:example/screens/text_form_field/text_form_field.screen.dart';
import 'package:example/screens/toggle_button/toggle_button.dart';
import 'package:example/screens/ui_widgets/comic_theme.screen.dart';
import 'package:example/screens/ui_widgets/sleek_theme.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:easystate/easystate.dart';

void main() {
  runApp(
    EasyState(
      state: AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Social Design System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  bool wideScreen = false;
  bool showSideMenu = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (const String.fromEnvironment('MODE') == 'noe') {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BirthdatePickerScreen()));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sideMenu(),
          Expanded(
            child: EasyStateBuilder<AppState>(
              builder: (_, state) => state.content,
            ),
          ),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        EasyState.of<AppState>(context).setContent(
                          const HomeContent(),
                        );
                        showSideMenu = false;
                        setState(() {});
                      },
                      child: const Text('Home')),
                  ElevatedButton(
                      onPressed: () {
                        showSideMenu = !showSideMenu;
                        setState(() {});
                      },
                      child: const Text('Menu')),
                ],
              ),
            ),
    );
  }

  Widget sideMenu() {
    if (!wideScreen && !showSideMenu) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(right: 16.0),
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Menu'),
            const ComicTheme(
              child: Divider(
                height: 24,
              ),
            ),

            menu(
              label: 'Home',
              contentBuilder: () => const HomeContent(),
            ),
            menu(
              label: 'Comic Theme',
              contentBuilder: () => const ComicScreenDemoScreen(),
            ),

            menu(
              label: 'Sleek Theme',
              contentBuilder: () => const SleekScreenDemoScreen(),
            ),

            menu(
              label: 'Comic Login',
              contentBuilder: () => const ComicLoginDemo(),
            ),

            menu(
              label: 'Sleek Login',
              contentBuilder: () => const SleekLoginDemo(),
            ),

            menu(
              label: 'Comic Theme UI Widgets',
              contentBuilder: () => const ComicThemeUiWidgetsScreen(),
            ),

            menu(
              label: 'Sleek Theme UI Widgets',
              contentBuilder: () => const SleekThemeUiWidgetsScreen(),
            ),

            const ComicTheme(
              child: Divider(
                height: 24,
              ),
            ),

            menu(
                label: 'Search Widget',
                contentBuilder: () => const SearchScreen()),
            menu(label: "AppBar", contentBuilder: () => const AppBarScreen()),
            menu(label: 'Badge', contentBuilder: () => const BadgeScreen()),

            menu(
                label: 'BottomAppBar',
                contentBuilder: () => const BottomAppBarScreen()),
            menu(
                label: 'BottomSheet',
                contentBuilder: () => const BottomSheetScreen()),
            menu(label: 'Buttons', contentBuilder: () => const ButtonsScreen()),
            menu(label: 'Card', contentBuilder: () => const CardScreen()),
            menu(
                label: 'Checkbox',
                contentBuilder: () => const CheckboxScreen()),

            // menu(label: 'CheckboxListTile', contentBuilder: () => const CheckboxListTileScreen()),
            menu(label: 'Chip', contentBuilder: () => const ChipScreen()),
            menu(label: 'Dialog', contentBuilder: () => const DialogScreen()),
            menu(label: 'Divider', contentBuilder: () => const DividerScreen()),
            menu(
                label: 'Dropdown',
                contentBuilder: () => const DropdownScreen()),
            menu(
                label: 'Floating Action Button',
                contentBuilder: () => const FloatingActionButtonScreen()),
            menu(
                label: 'IconButton',
                contentBuilder: () => const IconButtonScreen()),
            menu(
                label: 'ListTile',
                contentBuilder: () => const ListTileScreen()),
            menu(
                label: 'NavigationBar',
                contentBuilder: () => const NavigationBarScreen()),
            menu(
                label: "NavigationDrawer",
                contentBuilder: () => const NavigationDrawerScreen()),
            menu(
                label: 'NavigationRail',
                contentBuilder: () => const NavigationRailScreen()),
            menu(
                label: 'Progress Indicator',
                contentBuilder: () => const ProgressIndicatorScreen()),

            menu(
                label: 'Radio Button',
                contentBuilder: () => const RadioButtonScreen()),
            menu(
                label: 'Segmented Button',
                contentBuilder: () => const SegmentedButtonScreen()),
            menu(
                label: 'SnackBar',
                contentBuilder: () => const SnackBarScreen()),

            menu(label: 'Switch', contentBuilder: () => const SwitchScreen()),
            menu(label: 'TabBar', contentBuilder: () => const TabBarScreen()),
            menu(
                label: 'TextFields',
                contentBuilder: () => const TextFieldScreen()),
            menu(
                label: 'TextFormField',
                contentBuilder: () => const TextFormFieldScreen()),

            menu(
                label: 'Toggle Button',
                contentBuilder: () => const ToggleButtonScreen()),

            const Text('Custom Theme Data:'),
            const ComicTheme(
              child: Divider(
                height: 24,
              ),
            ),

            menu(
              label: 'ComicIconButtonThemeData',
              contentBuilder: () => const ComicIconButtonThemeDataContent(),
            ),
            menu(
              label: 'SleekIconButtonThemeData',
              contentBuilder: () => const SleekIconButtonThemeDataContent(),
            ),
            menu(
              label: 'ComicTextButtonThemeData',
              contentBuilder: () => const ComicTextButtonThemeDataContent(),
            ),

            const Text('Extensions:'),

            const ComicTheme(
              child: Divider(
                height: 24,
              ),
            ),

            menu(
              label: 'ComicBorder',
              contentBuilder: () => const ComicBorderScreen(),
            ),

            const Text('Custom Widgets:'),

            const ComicTheme(
              child: Divider(
                height: 24,
              ),
            ),

            menu(
                label: 'BirthdatePicker',
                contentBuilder: () => const BirthdatePickerScreen()),
            menu(
                label: 'ComicListView',
                contentBuilder: () => const ComicListViewScreen()),
            menu(
                label: 'SleekListView',
                contentBuilder: () => const SleekListViewScreen()),
            menu(label: 'Setting', contentBuilder: () => const SettingScreen()),
            menu(
                label: 'Basic Carousel Entry',
                contentBuilder: () => const BasicCarouselEntryScreen()),
            menu(
                label: 'Wave Carousel Entry',
                contentBuilder: () => const WaveCarouselEntryScreen()),
            menu(
                label: 'Round Carousel Entry',
                contentBuilder: () => const RoundCarouselEntryScreen()),
            menu(
                label: 'Sleep Walker',
                contentBuilder: () => const SleepWalkerScreen()),
            menu(
                label: 'Color scheme',
                contentBuilder: () => const ColorSchemeScreen()),
            menu(
                label: 'Current theme config',
                contentBuilder: () => const CurrentThemeScreen()),
          ],
        ),
      ),
    );
  }

  menu({
    required String label,
    required Widget Function() contentBuilder,
  }) {
    return ListTile(
      onTap: () {
        EasyState.of<AppState>(context).setContent(contentBuilder());
        showSideMenu = false;
        setState(() {});
      },
      title: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
