import 'package:example/screens/snackbar/comic.snackbar.screen.dart';
import 'package:example/screens/snackbar/sleek.snackbar.screen.dart';
import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';

class SnackBarScreen extends StatelessWidget {
  const SnackBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBars'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ComicSnackBarsScreen(),
                      ),
                    ),
                    child: const Text('Comic Style Snackbar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SleekSnackBarScreen(),
                      ),
                    ),
                    child: const Text('Sleek Style Snackbar'),
                  ),
                ],
              ),
              const NothingToLearn(),
              const Text(
                'SnackBar are splits into two different screens because of the reason its being dependent on Scaffold. ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
