import 'package:flutter/material.dart';

class HomeBuyAndSellScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeBuyAndSellScreen({super.key});

  @override
  State<HomeBuyAndSellScreen> createState() => _HomeBuyAndSellScreenState();
}

class _HomeBuyAndSellScreenState extends State<HomeBuyAndSellScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SafeArea(child: Text("Buy and Sell")),
      ],
    );
  }
}
