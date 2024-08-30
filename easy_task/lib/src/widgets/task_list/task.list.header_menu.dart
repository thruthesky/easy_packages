// import 'package:easy_locale/easy_locale.dart';
// import 'package:flutter/material.dart';

// class TaskListHeaderMenu extends StatelessWidget {
//   const TaskListHeaderMenu({super.key, required this.onTap});

//   final Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       icon: const Icon(Icons.settings),
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           child: CheckboxListTile(
//             value: true, //options.completed,
//             title: Text('Completed Tasks'.t),
//             onChanged: (v) {
//               // options.completed = v ?? false;
//               onTap();
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
