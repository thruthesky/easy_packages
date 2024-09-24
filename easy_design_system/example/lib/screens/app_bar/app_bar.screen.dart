import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class AppBarScreen extends StatefulWidget {
  const AppBarScreen({super.key});

  @override
  State<AppBarScreen> createState() => _AppBarScreenState();
}

class _AppBarScreenState extends State<AppBarScreen> {
  ThemeData? _themeData;

  @override
  Widget build(BuildContext context) {
    _themeData ??= Theme.of(context);
    return Theme(
      data: _themeData!,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AppBar"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
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
                      title: const Text("AppBar"),
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
                      title: const Text("AppBar"),
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
