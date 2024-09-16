# Easy Report

`easy_report` package provides an easy way of reporting and managing users, posts, comments, photos, chat, and other user generated contents. It is designed to be used in any kind of app that has user generated contents. It provides a way of reporting users and their contents.



# TODO

- Let admin list the reported users and their contents. And decide to block(disbable) their account. So that they cannot use the app.


# Concept

- It does not require an input from user to avoid the inconveniencing the user. Instead, it ask users to press a button for the reason of the report. And it offers three options. `Spam`, `Abusive`, `Other` and I think these are enough.

- It saves
  - The uid of the user who is responsible for the data. It can be the uid of the user who created the data or the uid of the user who is the admin of the data.
  - the path of the data. The data can be a path of realtime database or a path of firestore document.
  - The type of the data. It can be `user`, `post`, `comment`, `photo`, `chat`, etc.
  - The reason of the report. It can be `spam`, `abusive`, `other`.
  - The summary of the report. It can be a text that describes the report. Or it can be a text that describes the reason of the report. Or it can be a text that describes the data.


# Database Structure

- `reports` path
  - `reportId` data
    - `reportee` field: The uid of the user who is responsible for the data.
    - `reporter` field: The uid of the user who created the report. It is usually the login user's uid.

    - `path` field: The path of the data. It can be a path of realtime database or a path of firestore document.
    - `type` field: The type of the data. It can be `user`, `post`, `comment`, `photo`, `chat`, etc.
    - `reason` field: The reason of the report. It can be `spam`, `abusive`, `other`.
    - `summary` field: The summary of the report.
    - `createdAt` field: The time when the report is created.

# How to use

## Displaying a report button

You can display report button like this. And call the `report` method.

```dart
TextButton(
  onPressed: () async {
    await ReportService.instance.report(
      context: context,
      otherUid: user.uid,
      documentReference: user.ref,
    );
  },
  child: const Text('Report'),
),
```

## Displaying the list of blocks

You can display the list of blocked users.

```dart
ElevatedButton(
  onPressed: () =>
      ReportService.instance.showReportListScreen(context),
  child: const Text(
    'Report list',
  ),
),
```

## UI/UX customization

It's open source. You can simply open the source code of this package and copy/paste/edit the code. The code would be easy enough to re-use.

- To display the reports that the login user made, call `ReportService.instance.showReportListScreen()`.
- To customize the UI of the report list screen, you can create your own screen and use `ReportListView`.
  - `ReportListView` supports most of the properties of the list view widget.

# onCreate CallBack

The `onCreate` is a callback after the report is created. It contains the newly created `report` information.

Usage: (e.g. send push notification admin about the report)

In the example below, we can send push notification to admin after report is created.

```dart
    ReportService.instance.init(
      onCreate: (Report report) async {
        /// set push notification. e.g. send push notification to reportee
        /// or developer can send push notification to admin
        MessagingService.instance.sendMessageToUids(
          uids: [report.reportee],
          title: 'You have been reported',
          body: 'Report reason ${report.reason}',
          data: {
            "action": 'report',
            'reportId': report.id,
            'documentReference': report.documentReference.toString(),
          },
        );
      },
    );
```
