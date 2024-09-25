import 'package:flutter/material.dart';

/// Birthdate picker dialog
///
/// TODO name it as `DatePickerDialog` for more general use
class BirthdatePickerDialog extends StatefulWidget {
  const BirthdatePickerDialog({
    super.key,
    required this.onSelectedBirthDay,
    required this.onSelectedBirthMonth,
    required this.onSelectedBirthYear,
    required this.onSave,
    this.initialBirthDay,
    this.initialBirthMonth,
    this.initialBirthYear,
    this.birthYearLabel,
    this.birthMonthLabel,
    this.birthDayLabel,
    this.title,
    this.birthdayHint,
  });

  final Function(int?) onSelectedBirthDay;
  final Function(int?) onSelectedBirthMonth;
  final Function(int?) onSelectedBirthYear;
  final VoidCallback? onSave;
  final int? initialBirthDay;
  final int? initialBirthMonth;
  final int? initialBirthYear;
  final String? birthYearLabel;
  final String? birthMonthLabel;
  final String? birthDayLabel;
  final String? title;
  final String? birthdayHint;

  @override
  State<BirthdatePickerDialog> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdatePickerDialog> {
  int? birthYear;
  int? birthMonth;
  int? birthDay;

  @override
  void initState() {
    super.initState();

    birthDay = widget.initialBirthDay ?? 1;
    birthMonth = widget.initialBirthMonth ?? 1;
    birthYear = widget.initialBirthYear ?? 2000;
  }

  decorate(Widget child) {
    final isSleekTheme = Theme.of(context).dividerColor ==
        Theme.of(context).colorScheme.onPrimaryContainer;

    return InputDecorator(
      decoration: InputDecoration(
        fillColor:
            isSleekTheme ? Theme.of(context).colorScheme.primaryFixedDim : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.only(right: 8),
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSleekTheme = Theme.of(context).dividerColor ==
        Theme.of(context).colorScheme.onPrimaryContainer;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          Text(
            widget.title ?? 'Select Birth',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.birthYearLabel ?? 'Year',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    decorate(
                      DropdownButton<int>(
                          value: birthYear,
                          isExpanded: true,
                          items: [
                            for (int i = 2020; i >= 1950; i--)
                              birthdayMenuItem(i),
                          ],
                          onChanged: (v) {
                            setState(() => birthYear = v!);
                            widget.onSelectedBirthYear(v);
                          }),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.birthMonthLabel ?? 'Month',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    decorate(
                      DropdownButton<int>(
                        value: birthMonth,
                        isExpanded: true,
                        items: [
                          for (int i = 1; i <= 12; i++)
                            DropdownMenuItem(
                              value: i,
                              child: birthdayMenuItem(i),
                            ),
                        ],
                        onChanged: (v) {
                          setState(() => birthMonth = v!);
                          widget.onSelectedBirthMonth(v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.birthDayLabel ?? 'Day',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    decorate(
                      DropdownButton<int>(
                        value: birthDay,
                        items: [
                          for (int i = 1; i <= 31; i++)
                            DropdownMenuItem(
                                value: i, child: birthdayMenuItem(i)),
                        ],
                        onChanged: (v) {
                          setState(() {
                            birthDay = v!;
                          });

                          widget.onSelectedBirthDay(v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.birthdayHint ?? 'Please select your birthdate.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSleekTheme
                  ? Theme.of(context).colorScheme.primaryFixedDim
                  : null,
            ),
            child: const Text('Save'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  birthdayMenuItem(int i) => DropdownMenuItem(
        value: i,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            '$i',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
}
