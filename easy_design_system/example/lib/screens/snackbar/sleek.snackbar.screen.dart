import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SleekSnackBarScreen extends StatelessWidget {
  const SleekSnackBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SleekTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sleek SnackBar'),
          leading: IconButton(
            icon: const BackButtonIcon(),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('This is Sleek SnackBar'),
                    action: SnackBarAction(
                      onPressed: () {},
                      label: 'Action',
                    ),
                  ),
                ),
                child: const Text('Display Sleek SnackBar'),
              ),
              const NothingToLearn(),
            ],
          ),
        ),
      ),
    );
  }
}
