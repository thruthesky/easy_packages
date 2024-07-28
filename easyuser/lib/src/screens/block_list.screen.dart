import 'package:flutter/material.dart';

class BlockListScreen extends StatefulWidget {
  static const String routeName = '/BlockList';
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlockList'),
      ),
      body: const Column(
        children: [
          Text("BlockList"),
        ],
      ),
    );
  }
}
