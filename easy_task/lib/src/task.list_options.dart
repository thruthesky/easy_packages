class TaskListOptions {
  // bool completed;
  String menu;

  TaskListOptions({
    // required this.completed,
    required this.menu,
  });

  @override
  String toString() {
    return 'TaskListOptions{completed: completed, menu: $menu}';
  }
}
