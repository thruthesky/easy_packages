# Easy Report

`easy_report` package provides an easy way of reporting and managing users, posts, comments, photos, chat, and whatsoever.

It also provides a way of listing and blocking users.

## TODO

- Let admin list the reported users and their contents. And decide to block(disbable) their account. So that they cannot use the app.

## Concept

- It does not require typing to avoid the inconveniencing the user. Instead, it ask users to press a button for the reason of the report. And it offers three options. `Spam`, `Abusive`, `Other` and I think these are enough.

- It saves the user's uid and the document reference of the reporting. The document may be in any form (containing any fields).

- In admin screen, it displays the texts and uploads on the screen and let the admin choose to block the user or not.

- It can report any document as long as it provides a user uid to blame.
  - For instance,
    - For a group chat, there might be many master users and you want to report that that room. You can pass the reference of the chat room document(reference), and choose any of the master users to blame.
    - The option of `otherUid` is the one who is responsible for that document.

## How to use

### Displaying a report button

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

### Displaying the list of blocks

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

### UI/UX customization

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
