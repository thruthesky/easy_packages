import 'package:easy_messaging/easy_messaging.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  TextEditingController uidController =
      TextEditingController(text: 'GatA8bgsNlcGDEmQ5m4N3xhkVmZ2');
  TextEditingController tokenController = TextEditingController(
      text:
          'eXR2KTonTn2je2feP7K0AC:APA91bGXYxLIPhuMpia5xWphMbNHGVwcodcUPfdDUO7e8kXmbcSui40SJJjF5CuZxcYagfRQe1Y-Eo3hqOF8YsmjfeutCMAODGmB-xbE4UrnCkLJ4m3plW-_53431M6xGAC1zAftJFgP');
  TextEditingController subscriptionController =
      TextEditingController(text: 'testSubscription');
  TextEditingController titleController =
      TextEditingController(text: 'title ${DateTime.now()}');
  TextEditingController bodyController =
      TextEditingController(text: 'body ${DateTime.now()}');
  TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: uidController,
              decoration: InputDecoration(
                labelText: 'uid',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (uidController.text.isNotEmpty)
                      InkWell(
                        onTap: () => {
                          setState(() {
                            uidController.clear();
                          })
                        },
                        child: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                labelText: 'token',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tokenController.text.isNotEmpty)
                      InkWell(
                        onTap: () => {
                          setState(() {
                            tokenController.clear();
                          })
                        },
                        child: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: subscriptionController,
              decoration: InputDecoration(
                labelText: 'subscription',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (subscriptionController.text.isNotEmpty)
                      InkWell(
                        onTap: () => {
                          setState(() {
                            subscriptionController.clear();
                          })
                        },
                        child: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'title',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (titleController.text.isNotEmpty)
                      InkWell(
                        onTap: () => {
                          setState(() {
                            titleController.clear();
                          })
                        },
                        child: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                labelText: 'body',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bodyController.text.isNotEmpty)
                      InkWell(
                        onTap: () => {
                          setState(() {
                            bodyController.clear();
                          })
                        },
                        child: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // if (uidController.text.isEmpty) {
                    //   return;
                    // }
                    MessagingService.instance.sendMessageToUid(
                      uids: uidController.text.split(','),
                      title: 'From uid ${titleController.text}',
                      body: 'From uid ${bodyController.text}',
                      data: {},
                    );
                  },
                  child: const Text('Send To Uids'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // if (tokenController.text.isEmpty) {
                    //   return;
                    // }
                    MessagingService.instance.sendMessage(
                      tokens: tokenController.text.split(','),
                      title: 'From token ${titleController.text}',
                      body: 'From token ${bodyController.text}',
                      data: {},
                    );
                  },
                  child: const Text('Send To Tokens'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // if (subscriptionController.text.isEmpty) {
                    //   return;
                    // }
                    MessagingService.instance.sendMessageToSubscription(
                      subscription: subscriptionController.text,
                      title: 'From Subscription ${titleController.text}',
                      body: 'From Subscription ${bodyController.text}',
                      data: {},
                    );
                  },
                  child: const Text('Send To Subscription'),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
