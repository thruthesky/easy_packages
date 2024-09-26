import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class CheckboxListTileScreen extends StatefulWidget {
  const CheckboxListTileScreen({super.key});

  @override
  State<CheckboxListTileScreen> createState() => _CheckboxListTileScreenState();
}

class _CheckboxListTileScreenState extends State<CheckboxListTileScreen> {
  bool comicCheckBoxOn = true;
  bool comicCheckBoxOff = false;

  bool sleekCheckBoxOn = true;
  bool sleekCheckBoxOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckboxListTile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16),
              child: Text('ComicTheme'),
            ),
            Theme(
              data: ComicTheme.of(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CheckboxListTile(
                        value: comicCheckBoxOn,
                        onChanged: (bool? value) {
                          setState(() {
                            comicCheckBoxOn = value!;
                          });
                        },
                        title: const Text('On')),
                    const SizedBox(
                      height: 8,
                    ),
                    CheckboxListTile(
                        value: comicCheckBoxOff,
                        onChanged: (bool? value) {
                          setState(() {
                            comicCheckBoxOff = value!;
                          });
                        },
                        title: const Text('Off')),
                    const SizedBox(
                      height: 8,
                    ),
                    const CheckboxListTile(
                        value: true,
                        onChanged: null,
                        title: Text('On Disabled')),
                    const SizedBox(
                      height: 8,
                    ),
                    const CheckboxListTile(
                      value: false,
                      onChanged: null,
                      title: Text('Off Disabled'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16),
              child: Text('SleekTheme'),
            ),
            Theme(
              data: SleekTheme.of(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CheckboxListTile(
                        value: comicCheckBoxOn,
                        onChanged: (bool? value) {
                          setState(() {
                            comicCheckBoxOn = value!;
                          });
                        },
                        title: const Text('On')),
                    const SizedBox(
                      height: 8,
                    ),
                    CheckboxListTile(
                        value: comicCheckBoxOff,
                        onChanged: (bool? value) {
                          setState(() {
                            comicCheckBoxOff = value!;
                          });
                        },
                        title: const Text('Off')),
                    const SizedBox(
                      height: 8,
                    ),
                    const CheckboxListTile(
                        value: true,
                        onChanged: null,
                        title: Text('On Disabled')),
                    const SizedBox(
                      height: 8,
                    ),
                    const CheckboxListTile(
                        value: false,
                        onChanged: null,
                        title: Text('Off Disabled'))
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: NothingToLearn(),
            )
          ],
        ),
      ),
    );
  }
}
