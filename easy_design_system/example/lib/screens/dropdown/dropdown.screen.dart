import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class DropdownScreen extends StatefulWidget {
  const DropdownScreen({super.key});

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dropdown Screen")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Table(
                children: const [
                  TableRow(
                    children: [
                      Text("Comic Theme"),
                      Text("Sleek There"),
                    ],
                  ),
                  TableRow(
                    children: [
                      ComicTheme(child: DropDownExample()),
                      SleekTheme(child: DropDownExample()),
                    ],
                  ),
                ],
              ),
              const NothingToLearn()
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownExample extends StatefulWidget {
  const DropDownExample({super.key});

  @override
  State<DropDownExample> createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  final TextEditingController menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String dropdownValue = list.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
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
        const SizedBox(
          height: 24,
        ),
        MenuBar(
          children: <Widget>[
            SubmenuButton(
              menuChildren: <Widget>[
                SubmenuButton(
                  menuChildren: <Widget>[
                    MenuItemButton(
                      onPressed: () {},
                      child: const MenuAcceleratorLabel('&Forms'),
                    ),
                  ],
                  child: const MenuAcceleratorLabel('&New'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved!'),
                      ),
                    );
                  },
                  child: const MenuAcceleratorLabel('&Save'),
                ),
                MenuItemButton(
                  onPressed: () {},
                  child: const MenuAcceleratorLabel('&Quit'),
                ),
              ],
              child: const MenuAcceleratorLabel('&File'),
            ),
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {},
                  child: const MenuAcceleratorLabel('&Magnify'),
                ),
                MenuItemButton(
                  onPressed: () {},
                  child: const MenuAcceleratorLabel('Mi&nify'),
                ),
              ],
              child: const MenuAcceleratorLabel('&View'),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const Text('Popup Menu'),
            PopupMenuButton<String>(
              initialValue: '',
              onSelected: (String item) {},
              itemBuilder: (BuildContext context) =>
                  list.map<PopupMenuEntry<String>>((String v) {
                return PopupMenuItem<String>(
                  value: v,
                  child: Text(v),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const Text('Menu Anchor'),
            MenuAnchor(
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
              menuChildren: list.map((String v) {
                return MenuItemButton(
                  onPressed: () => {},
                  child: Text(v),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
