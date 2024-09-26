import 'package:flutter/material.dart';

/// A date picker widget.
///
/// The date picker widget allows users to select a date.
///
/// [DatePicker] requires an [onChanged] callback to be provided. This callback
/// will be called when the user selects a date. The callback provides the
/// selected year, month, and day.
///
/// The [beginYear] and [endYear] properties can be used to specify the range of
/// years that the user can select. If these properties are not provided, the
/// range of years will be from the current year to the current year plus 16.
///
/// The [ascendingYear] property can be used to specify whether the years should
/// be displayed in ascending order. By default, the years are displayed in
/// ascending order.
///
/// The [initialDate] property can be used to specify the initial date that the
/// user should be displaying on initialization (ex. geting data from database).
/// If this property is not provided, the initial will display the default value
/// on first load.
class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    this.beginYear,
    this.endYear,
    this.ascendingYear = true,
    required this.onChanged,
    this.labelYear = 'Year',
    this.labelMonth = 'Month',
    this.labelDay = 'Day',
    this.initialDate,
  });

  final int? beginYear;
  final int? endYear;
  final bool ascendingYear;
  final void Function(int year, int month, int day) onChanged;

  final String labelYear;
  final String labelMonth;
  final String labelDay;
  final ({int? year, int? month, int? day})? initialDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late int beginYear;
  late int endYear;
  late int year;
  int month = 1;
  int day = 1;

  @override
  void initState() {
    super.initState();
    beginYear = widget.beginYear ?? DateTime.now().year;
    endYear = widget.endYear ?? DateTime.now().year + 16;
    year = widget.ascendingYear ? beginYear : endYear;

    prepareInitialData();
  }

  void prepareInitialData() {
    if (widget.initialDate != null) {
      year = widget.initialDate!.year ?? year;
      month = widget.initialDate!.month ?? month;
      day = widget.initialDate!.day ?? day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelYear,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              decorate(
                DropdownButton<int>(
                  value: year,
                  isExpanded: true,
                  items: [
                    if (widget.ascendingYear)
                      for (int i = beginYear; i <= endYear; i++)
                        birthdayMenuItem(i)
                    else
                      for (int i = endYear; i >= beginYear; i--)
                        birthdayMenuItem(i)
                  ],
                  onChanged: (v) {
                    setState(() => year = v!);
                    widget.onChanged(year, month, day);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.4),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelMonth,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              decorate(
                DropdownButton<int>(
                  value: month,
                  isExpanded: true,
                  items: [
                    for (int i = 1; i <= 12; i++)
                      DropdownMenuItem(
                        value: i,
                        child: birthdayMenuItem(i),
                      ),
                  ],
                  onChanged: (v) {
                    setState(() => month = v!);
                    widget.onChanged(year, month, day);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.4),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelDay,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              decorate(
                DropdownButton<int>(
                  value: day,
                  items: [
                    for (int i = 1; i <= 31; i++)
                      DropdownMenuItem(value: i, child: birthdayMenuItem(i)),
                  ],
                  onChanged: (v) {
                    setState(() => day = v!);
                    widget.onChanged(year, month, day);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  decorate(Widget child) => InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.only(right: 8),
          isDense: true,
        ),
        child: DropdownButtonHideUnderline(child: child),
      );

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
