# Date Picker


A simple and easy to use date-picker widget.


## How to use


|Properties|Description|
|-----|-----|
|onChanged|It will be called when the user selects a date with the selected year, month, and day.|
|beginYear| ... |
|endYear| ... |
|ascendingyear| ... |
|lableYear| ... |
|lableMonth| ... |
|lableDay| ... |
|initialDate| You can set initial date by using this property. ( initial year can only be within the range of beginYear and endYear).|





```dart

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyHomePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            DatePicker(
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
            DatePicker(
              beginYear: 2020,
              endYear: 2029,
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
            DatePicker(
              beginYear: 2020,
              endYear: 2029,
              ascendingYear: false,
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
             DatePicker(
              beginYear: 2020,
              endYear: 2029,
              ascendingYear: false,
              initialDate: (year: 2025, month: 11, day: 17),
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
              const SizedBox(height: 24.0),
             DatePicker(
              beginYear: 2020,
              endYear: 2029,
              ascendingYear: false,
              initialDate: (year: 2025, month: null, day: null),
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DatePickerDialog(),
                );
              },
              child: const Text('Select a date in a dialog'),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerDialog extends StatelessWidget {
  const DatePickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            DatePicker(
              onChanged: (year, month, day) => print('$year, $month, $day'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
```