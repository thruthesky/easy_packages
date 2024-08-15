import 'package:easyuser/src/widgets/block.list_view.dart';
import 'package:flutter/material.dart';

class UserBlockListScreen extends StatefulWidget {
  static const String routeName = '/BlockList';
  const UserBlockListScreen({super.key});

  @override
  State<UserBlockListScreen> createState() => _UserBlockListScreenState();
}

class _UserBlockListScreenState extends State<UserBlockListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Block List'),
      ),
      body: const BlockListView(),
    );
  }
}
