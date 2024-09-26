import 'package:example/widgets/code_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class BirthdatePickerScreen extends StatefulWidget {
  static const routeName = '/birthday_picker';

  const BirthdatePickerScreen({super.key});

  @override
  State<BirthdatePickerScreen> createState() => _BirthdatePickerScreenState();
}

class _BirthdatePickerScreenState extends State<BirthdatePickerScreen> {
  int? day;
  int? month;
  int? year;
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthdate Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text('Sleek Theme'),
              ComicTheme(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ComicTheme(
                        child: BirthdatePickerDialog(
                          initialBirthDay: day,
                          initialBirthMonth: month,
                          initialBirthYear: year,
                          onSelectedBirthDay: (v) {
                            debugPrint(v.toString());
                            day = v!;
                            setState(() {});
                          },
                          onSelectedBirthMonth: (v) {
                            debugPrint(v.toString());
                            month = v!;
                          },
                          onSelectedBirthYear: (v) {
                            debugPrint(v.toString());
                            year = v!;
                          },
                          onSave: () {
                            if (day == null || month == null || year == null) {
                              Navigator.pop(context);
                              return;
                            }

                            debugPrint('$day/$month/$year');
                            text = '$day/$month/$year';
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.calendar_month),
                  title:
                      text.isEmpty ? const Text('Select birthday') : Text(text),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Sleek Theme'),
              SleekTheme(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SleekTheme(
                        child: BirthdatePickerDialog(
                          initialBirthDay: day,
                          initialBirthMonth: month,
                          initialBirthYear: year,
                          onSelectedBirthDay: (v) {
                            debugPrint(v.toString());
                            day = v!;
                            setState(() {});
                          },
                          onSelectedBirthMonth: (v) {
                            debugPrint(v.toString());
                            month = v!;
                          },
                          onSelectedBirthYear: (v) {
                            debugPrint(v.toString());
                            year = v!;
                          },
                          onSave: () {
                            if (day == null || month == null || year == null) {
                              Navigator.pop(context);
                              return;
                            }

                            debugPrint('$day/$month/$year');
                            text = '$day/$month/$year';
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.calendar_month),
                  title:
                      text.isEmpty ? const Text('Select birthday') : Text(text),
                ),
              ),
              const CodeToLearn(md: '''
## BirthdatePickerDialog
- The `BirthdatePickerDialog` is a custom widget within our social design system designed to 
  facilitate the selection of birthdays. It enables users to easily choose their birthday from a dialog.
- To Apply a Theme, simply wrap the `BirthdatePickerDialog` widget with the `ComicTheme` widget.

```dart
ComicTheme(
  child: ListTile(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => ComicTheme(
          child: BirthdatePickerDialog(
            initialBirthDay: day,
            initialBirthMonth: month,
            initialBirthYear: year,
            onSelectedBirthDay: (v) {
              debugPrint(v.toString());
            },
            onSelectedBirthMonth: (v) {
              debugPrint(v.toString());
            },
            onSelectedBirthYear: (v) {
              debugPrint(v.toString());
            },
            onSave: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
    trailing: const Icon(Icons.calendar_month),
    title:Text('Select birthday') ,
  ),
),
```
          '''),
              const SizedBox(
                height: 48,
              )
            ],
          ),
        ),
      ),
    );
  }
}
