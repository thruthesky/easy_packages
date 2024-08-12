import 'package:easy_messaging/easy_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationToggelIcon extends StatelessWidget {
  const PushNotificationToggelIcon({
    super.key,
    required this.category,
    this.widgetOn = const Icon(Icons.notifications_rounded),
    this.widgetOff = const Icon(Icons.notifications_off_outlined),
  });

  final String category;
  final Widget widgetOn;
  final Widget widgetOff;

  @override
  Widget build(BuildContext context) {
    final MessagingService messagingService = MessagingService.instance;
    return IconButton(
      onPressed: () async {
        messagingService.toggle(
            ref: messagingService.subscriptionRef(category));
      },
      icon: Value(
        ref: messagingService.subscriptionRef(category),
        builder: (v) => v == true ? widgetOn : widgetOff,
      ),
    );
  }
}
