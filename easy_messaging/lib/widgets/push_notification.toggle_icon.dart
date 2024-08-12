import 'package:easy_messaging/easy_messaging.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/material.dart';

class PushNotificationToggelIcon extends StatelessWidget {
  const PushNotificationToggelIcon({
    super.key,
    required this.subscriptionName,
    this.widgetOn = const Icon(Icons.notifications_rounded),
    this.widgetOff = const Icon(Icons.notifications_off_outlined),
  });

  final String subscriptionName;
  final Widget widgetOn;
  final Widget widgetOff;

  @override
  Widget build(BuildContext context) {
    final MessagingService messagingService = MessagingService.instance;
    return IconButton(
      onPressed: () async {
        // messagingService.toggle(
        //     ref: messagingService.subscriptionRef(subscriptionName));
      },
      icon: Value(
        ref: messagingService.subscriptionRef(subscriptionName),
        builder: (v, ref) => v == true ? widgetOn : widgetOff,
      ),
    );
  }
}
