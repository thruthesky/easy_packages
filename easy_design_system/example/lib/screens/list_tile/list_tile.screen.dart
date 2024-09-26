import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ListTileScreen extends StatefulWidget {
  static const String routeName = '/ListTile';
  const ListTileScreen({super.key});

  @override
  State<ListTileScreen> createState() => _ListTileScreenState();
}

class _ListTileScreenState extends State<ListTileScreen> {
  bool comicCheckbox = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListTile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: ComicTheme.of(context),
                child: const Column(
                  children: [
                    Text('Comic Theme'),
                    ListTile(
                      title: Text('ListTile'),
                      subtitle: Text('Subtitle'),
                      leading: Icon(Icons.ac_unit),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),

                    // Text('Comic Theme'),
                    // ListTile(
                    //   title: Text('ListTile'),
                    //   subtitle: Text('Subtitle'),
                    //   leading: Icon(Icons.ac_unit),
                    //   trailing: Icon(Icons.arrow_forward_ios),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Theme(
                data: SleekTheme.of(context),
                child: const Column(
                  children: [
                    Text('Sleek Theme'),
                    ListTile(
                      title: Text('ListTile'),
                      subtitle: Text('Subtitle'),
                      leading: Icon(Icons.ac_unit),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Comic Theme CheckBoxListTile'),
              ComicTheme(
                child: CheckboxListTile(
                  value: comicCheckbox,
                  onChanged: (bool? value) {
                    setState(() {
                      comicCheckbox = value!;
                    });
                  },
                  title: const Text('Comic Theme CheckboxListTile'),
                  subtitle: const Text('On'),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Sleek Theme CheckBoxListTile'),
              SleekTheme(
                child: CheckboxListTile(
                  value: comicCheckbox,
                  onChanged: (bool? value) {
                    setState(() {
                      comicCheckbox = value!;
                    });
                  },
                  title: const Text('Sleek Theme CheckboxListTile'),
                  subtitle: const Text('On'),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Comic Theme RadioListTile'),
              ComicTheme(
                child: RadioListTile(
                  groupValue: 'Y',
                  value: 'Y',
                  onChanged: (v) {},
                  title: const Text('Comic Theme CheckboxListTile'),
                  subtitle: const Text('On'),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Sleek Theme RadioListTile'),
              SleekTheme(
                child: RadioListTile(
                  groupValue: 'Y',
                  value: 'Y',
                  onChanged: (v) {},
                  title: const Text('Sleek Theme CheckboxListTile'),
                  subtitle: const Text('On'),
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
