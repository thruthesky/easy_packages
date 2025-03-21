# 🧩 easy_design_system

**Effortless UI/UX for Flutter** – Build beautiful apps with no extra learning.

---

## ✨ Overview

`easy_design_system` is an elegant, zero-learning-curve design system built for Flutter developers who want to enhance UI/UX **without having to learn a new library**.

While most design systems come with custom widgets, new APIs, and a learning curve, `easy_design_system` works differently — it **extends Flutter's native design language** so you can use it right out of the box.

> 💡 **Nothing to learn. Just use it.**

---

## 🚀 Why use `easy_design_system`?

- 🔥 **Zero Learning Curve** – No need to study new APIs or read docs.
- 🎯 **Familiar API** – Built on top of Flutter’s default `ThemeData` and `Material Design`.
- 🎨 **Beautiful Design** – Polished components and clean defaults for modern UI.
- 🛠️ **Developer Friendly** – Designed to save time and reduce boilerplate.
- 💬 **Open Source** – Fork it, tweak it, and contribute back!

---

## 🛠️ Getting Started

### 1. Install the package

```yaml
dependencies:
  easy_design_system: ^<latest_version>
```

### 2. Import the package

```dart
import 'package:easy_design_system/easy_design_system.dart';
```

### 3. Use the design system

Wrap your app with `EasyDesignSystem` and choose a theme:

```dart
import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      // Apply the Comic theme
      Theme(
        data: ComicTheme.of(context),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Input your name'),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hello, ${nameController.text}')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

To learn more, please visit the [Easy Design System document website](https://thruthesky.github.io/easy_design_system_backup_2024_09_24/).

## Entry Screens

Easy Design System provides a starting screen for your app.

|                                                       BasicCarouselEntry                                                        |                                                       WaveCarouselEntry                                                       |                                                       RoundCarouselEntry                                                        |
| :-----------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------: |
| ![BasicCarouselEntry](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/basic_carousel_entry.jpg?raw=true) | ![WaveCarouselEntry](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/wave_carousel_entry.jpg?raw=true) | ![RoundCarouselEntry](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/round_carousel_entry.jpg?raw=true) |

## Demos

Here are some demos of the Easy Design System (SDS).

|                                                        Comic Theme                                                         |                                                        Sleek Theme                                                         |
| :------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------: |
| ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/demo.comic.home.screen.jpg?raw=true)  | ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/demo.sleek.home.screen.jpg?raw=true)  |
| ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/demo.comic.login.screen.jpg?raw=true) | ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/demo.sleek.login.screen.jpg?raw=true) |
|   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/comic.widgets.tab_1.jpg?raw=true)   |   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/sleek.widgets.tab_1.jpg?raw=true)   |
|   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/comic.widgets.tab_2.jpg?raw=true)   |   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/sleek.widgets.tab_2.jpg?raw=true)   |
|   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/comic.widgets.tab_3.jpg?raw=true)   |   ![DemoScreen](https://github.com/thruthesky/easy_design_system/blob/main/docs/images/sleek.widgets.tab_3.jpg?raw=true)   |

## Usage

Easy Design System follows the principle of the Flutter programming style. You can continue with Flutter coding without knowing how to apply the UI design.

For instance, SDS provides `ComicTheme` and you can use it like below;

```dart
Theme(
    data: ComicTheme.of(context),
    child: const ListTile(
    title: Text('Item 1'),
    subtitle: Text('Subtitle 1'),
    leading: Icon(Icons.access_time),
    trailing: Icon(Icons.arrow_forward_ios),
    ),
),
```

As you know this is the way how the Flutter goes.

You may use the `ComicTheme` widget for short like below;

```dart
const ComicTheme(
    child: ListTile(
    title: Text('Item 2'),
    subtitle: Text('Subtitle 2'),
    leading: Icon(Icons.access_alarm),
    trailing: Icon(Icons.arrow_forward_ios),
    ),
),
```

For more details, please visit the [Easy Design System document website](https://thruthesky.github.io/easy_design_system_backup_2024_09_24/)

## Things to learn

### Comic theme

- Comic theme uses

  - outline with outline color.
  - background color with the surface color.

- You can set `comicBorderWidth` before using the `ComicTheme` widget. With this, you can control the border width of the outline.

```dart
Widget build(BuildContext context) {
  comicBorderWidth = 1.0;
  return MaterialApp.router(
    theme: ComicTheme.of(context).copyWith(),
  );
}
```

### Sleek theme

- Sleek theme uses
  - background color with primaryContainer.

## Contribution

- Fork and PR.
- Leave your issues on the git repo.

## How to build and run

- Fork (or clone) the project.
- Run the example project

.
