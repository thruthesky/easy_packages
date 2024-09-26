import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class BottomAppBarScreen extends StatelessWidget {
  const BottomAppBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BottomAppBarScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Comic"),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: Scaffold(
                  bottomNavigationBar: Theme(
                    data: ComicTheme.of(context),
                    child: BottomAppBar(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.home),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text("Sleek"),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: Scaffold(
                  bottomNavigationBar: Theme(
                    data: SleekTheme.of(context),
                    child: BottomAppBar(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.home),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const NothingToLearn(),
            ],
          ),
        ),
      ),
    );
  }
}
