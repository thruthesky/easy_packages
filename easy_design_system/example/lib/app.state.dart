// Define your state class extending(or mixing with) the ChangeNotifier
import 'package:example/contents/home.content.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  Widget content = const HomeContent();
  void setContent(Widget content) {
    this.content = content;
    notifyListeners();
  }

  // int count = 0;
  // void increment() {
  //   count++;
  //   // Notify listeners to rebuild the widgets.
  //   notifyListeners();
  // }
}
