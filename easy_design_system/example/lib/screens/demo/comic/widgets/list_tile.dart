import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ListTileDemo extends StatelessWidget {
  const ListTileDemo({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: Text(title),
      subtitle:
          const Text('Comic Theme is a theme that is inspired by comic books.'),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Theme(
            data: ComicTheme.of(context),
            child: BottomSheet(
              onClosing: () {},
              builder: (context) => const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Comic'),
                ),
              ),
            ),
          ),
        );
      },
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
