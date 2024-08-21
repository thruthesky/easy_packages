import 'package:easy_messaging/easy_messaging.dart';
import 'package:easyuser/easyuser.dart';
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
          'cdgqMhK3QGm7pfBELsHQUq:APA91bGP8XoW1u6UOTZ_Q1gTwUvDLU5sMFCa9jFc0fbv2nKzl1Odu-LfBzJn8ejDIsTkiBE1mcNMZqchHzi5OXDSOztqyQBgMi8Ipx4MJztrivkpiZ5FAPM-SV8AlN3lx2eRuuXXsSZ9');
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
                    MessagingService.instance.sendMessageToUids(
                      uids: uidController.text.split(','),
                      title: 'From uid ${titleController.text}',
                      body: 'From uid ${bodyController.text}',
                      data: {'action': 'uid', 'extra': 'rice'},
                    );
                  },
                  child: const Text('Send To Uids'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // if (tokenController.text.isEmpty) {
                    //   return;
                    // }
                    MessagingService.instance.sendMessageToTokens(
                      tokens: tokenController.text.split(','),
                      title: 'From token ${titleController.text}',
                      body: 'From token ${bodyController.text}',
                      data: {'action': 'uid', 'extra': 'fries'},
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
                      data: {'action': 'uid', 'extra': 'dice'},
                    );
                  },
                  child: const Text('Send To Subscription'),
                ),
              ],
            ),
            const Divider(),
            const Text('Subscribe to testSubscription'),
            AuthStateChanges(builder: (u) {
              if (u == null) return const Text('Must login first');

              return const PushNotificationToggleIcon(
                subscriptionName: 'testSubscription',
              );
            }),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
