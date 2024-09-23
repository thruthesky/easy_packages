import 'package:date_picker_v2/date_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = '/MyHomePage';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
              initialDate: (year: 2023, month: null, day: null),
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
