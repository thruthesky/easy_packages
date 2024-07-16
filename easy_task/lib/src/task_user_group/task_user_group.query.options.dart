import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class TaskUserGroupQueryOptions {
  const TaskUserGroupQueryOptions({
    this.limit = 20,
    this.orderBy = 'updatedAt',
    this.orderByDescending = true,
    this.usersContain,
    this.moderatorUsersContain,
    this.invitedUsersContain,
    this.rejectedUsersContain,
  });

  final int limit;
  final String orderBy;
  final bool orderByDescending;
  final String? usersContain;
  final String? moderatorUsersContain;
  final String? invitedUsersContain;
  final String? rejectedUsersContain;

  /// Query Options for groups that invited me
  TaskUserGroupQueryOptions.invitedMe() : this(invitedUsersContain: myUid!);

  /// Query Options for groups that I rejected
  TaskUserGroupQueryOptions.myRejects() : this(rejectedUsersContain: myUid!);

  /// Query Options for groups that I
  /// either moderate or joined (accepted invitation).
  TaskUserGroupQueryOptions.involvesMe()
      : this(
          moderatorUsersContain: myUid!,
          usersContain: myUid,
        );

  /// Query Options for groups that I accepted
  TaskUserGroupQueryOptions.myJoins() : this(usersContain: myUid!);

  Map<String, dynamic> get options => {
        if (usersContain != null) "users": usersContain,
        if (moderatorUsersContain != null)
          "moderatorUsers": moderatorUsersContain,
        if (invitedUsersContain != null) "invitedUsers": invitedUsersContain,
        if (rejectedUsersContain != null) "rejectedUsers": rejectedUsersContain
      };

  Query get getQuery {
    Query groupQuery = TaskUserGroup.col;
    if (options.length == 1) {
      groupQuery = groupQuery.where(
        options.keys.first,
        arrayContains: options.values.first,
      );
    } else if (options.length >= 2) {
      groupQuery = groupQuery.where(
        Filter.or(
          Filter(
            options.keys.first,
            arrayContains: options.values.first,
          ),
          Filter(
            options.keys.elementAt(1),
            arrayContains: options.values.elementAt(1),
          ),
          options.length >= 3
              ? Filter(
                  options.keys.elementAt(2),
                  arrayContains: options.values.elementAt(2),
                )
              : null,
          options.length >= 4
              ? Filter(
                  options.keys.elementAt(3),
                  arrayContains: options.values.elementAt(3),
                )
              : null,
        ),
      );
    }
    groupQuery = groupQuery
        .orderBy(
          orderBy,
          descending: orderByDescending,
        )
        .limit(limit);
    return groupQuery;
  }
}
