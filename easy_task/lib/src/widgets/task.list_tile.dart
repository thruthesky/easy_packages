import 'dart:async';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatefulWidget {
  const TaskListTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool checked = false;

  @override
  void initState() {
    super.initState();
    checked = widget.task.completed;
  }

  @override
  void didUpdateWidget(covariant TaskListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    checked = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.task.project
                ? const SizedBox(
                    width: 48, height: 48, child: Icon(Icons.diversity_1))
                : Checkbox(
                    value: checked,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          checked = value;
                        });

                        if (widget.task.parent != null) {
                          widget.task.toggleCompleted(value);
                          return;
                        }

                        /// Delay the task completion to show the animation
                        /// Purpose: to let the user know why the task is not being disappeared immediately
                        /// Without this delay, the task will be disappeared immediately and use may be confused
                        Timer(const Duration(milliseconds: 460), () async {
                          await widget.task.toggleCompleted(value);
                        });
                      }
                    },
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.task.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (widget.task.urls.isNotEmpty) const Icon(Icons.photo_outlined),
            const Icon(Icons.chevron_right),
            const SizedBox(width: 8),
          ],
        ),
      ),
      onTap: () {
        if (widget.task.project) {
          TaskService.instance.showProjectDetailScreen(context, widget.task);
        } else {
          TaskService.instance.showTaskDetailScreen(context, widget.task);
        }
      },
    );
  }
}
