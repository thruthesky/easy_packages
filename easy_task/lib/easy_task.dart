// EASY TASK EXPORTS

// TASK SERVICE ========
export 'src/task.service.dart';

// TASK ================
export 'src/task/task.dart';
export 'src/task/task.query.options.dart';
// Task Widgets
export 'src/task/widgets/task.list_view.dart';
// Task Screens
export 'src/task/screens/task.create.screen.dart';
export 'src/task/screens/task.detail.screen.dart';
export 'src/task/screens/task.update.screen.dart';

// ASSIGN ===============
export 'src/assign/assign.dart';
export 'src/assign/assign.query.options.dart';
// Assign Widgets
export 'src/assign/widgets/assign.list_view.dart';
// Assign Screens
export 'src/assign/screens/assign.detail.screen.dart';

// GROUP ================
export 'src/task_user_group/task_user_group.dart';
export 'src/task_user_group/task_user_group.query.options.dart';
// Group Widgets
export 'src/task_user_group/widgets/task_user_group.list_view.dart';
// Group Screens
export 'src/task_user_group/screens/task_user_group.create.screen.dart';
export 'src/task_user_group/screens/task_user_group.detail.screen.dart';

// Others ===============
export 'src/functions.dart';
// Unit Test
export 'unit_tests/task/task.unit_test.dart';

// FOR REVIEW ===========
// NOTE: User should not be exported
//       Because this should be handled
//       by the app and should be
//       independent from this package.
// export 'src/user.dart';
// export 'src/defines.dart';