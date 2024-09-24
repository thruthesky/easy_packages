import 'package:example/screens/demo/comic/widgets/bottom_sheet.demo.dart';
import 'package:example/screens/demo/comic/widgets/check_box.demo.dart';
import 'package:example/screens/demo/comic/widgets/news.tile.dart';
import 'package:example/screens/demo/comic/widgets/post.tile.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Text(
                  "Welcome to Comic Theme Demonstration Page. This is the Dashboad. Explore the Comic Theme to check out the different Widgets.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // const Card(child: Text('Card has a border already')),
                const SizedBox(height: 24),
                Text(
                  "Weather Forecast",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      const ListTileTheme(
                        child: ListTile(
                          title: Text('32 °C | 89 °F (A bit rainy)'),
                          subtitle:
                              Text('Monday\nLight thunderstorms and rain'),
                          leading: Icon(Icons.cloud),
                        ),
                      ),
                      Column(
                        children: [
                          const Divider(
                            indent: 16,
                            endIndent: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 12.0, top: 8),
                            child: Text(
                              "Today. Not a real data: Maximum daytime temperature: 32 degrees Celsius; Minimum nighttime temperature: 28 degrees Celsius.",
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Are you happy today?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Congratulations! There is one less sad person in the world!',
                        ),
                        action: SnackBarAction(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          label: 'Dismiss',
                        ),
                      ),
                    );
                  },
                  label: const Text('Tap/Click if YES!'),
                  icon: const Icon(Icons.emoji_emotions_outlined),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                // const ListTileDemo(),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text("Comic ListTile"),
                  subtitle: const Text('Tap to learn more about comic theme.'),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Theme(
                        data: ComicTheme.of(context),
                        child: BottomSheet(
                          onClosing: () {},
                          builder: (context) => const SizedBox(
                            height: 200,
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Comic Theme is a theme that is inspired by comic books. The main idea is about thick borders with no background coloring. However, as a developer, you may choose how you want to color your app.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const SizedBox(height: 24),
                const BottomSheetDemo(),
                const CheckBoxDemo(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostTile(
                  title: "Jerremy Comilang",
                  subtitle: "john.mclean@aplepetstore.com",
                  content:
                      "In the heart of the forest, where the trees whispered ancient secrets, a hidden village thrived. The villagers lived in harmony with nature, their days filled with laughter and song. Mysterious lights danced in the night sky, guiding travelers to safety. Legends spoke of a guardian spirit, protecting all who called this enchanted place home.",
                ),
                PostTile(
                  title: "Ma. Cecilia L. Comilang",
                  subtitle: "cormilang@ss.com",
                  content:
                      "Beneath the starry sky, a cat with emerald eyes roamed the quiet streets. Shadows danced under the moonlight as the breeze carried whispers of forgotten tales. In the distance, a clock tower chimed midnight, signaling the start of another magical night.",
                ),
                PostTile(
                  title: "Harry Flores",
                  subtitle: "florensia@saniba.com",
                  content:
                      "Under the moonlit sky, a lone owl hooted from an ancient oak. Fireflies flickered, painting the night with tiny sparks of light, while the world slept peacefully.",
                ),
              ],
            ),
          ),
        ),
        const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NewsTile(),
                NewsTile(),
                NewsTile(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
