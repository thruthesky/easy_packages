import 'package:easy_messaging/easy_messaging.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/material.dart';

///
/// Simple toggle notificationIcon
///
/// [subscriptionName] string where the toggle will be set
///  eg. /$path/$subscriptionName/$uid: true
///
/// [reverse] reverse the icon display from on/off to off/on
///
/// Or you can provide [widgetOn] as `offIcon` and [widgetOff] as `onIcon` icon to make it look reverse.
///
class PushNotificationToggleIcon extends StatelessWidget {
  const PushNotificationToggleIcon({
    super.key,
    required this.subscriptionName,
    this.reverse = false,
    this.widgetOn = const Icon(Icons.notifications_rounded),
    this.widgetOff = const Icon(Icons.notifications_off_outlined),
  });

  final String subscriptionName;
  final bool reverse;
  final Widget widgetOn;
  final Widget widgetOff;

  Widget get onWidget => reverse ? widgetOff : widgetOn;
  Widget get offWidget => reverse ? widgetOn : widgetOff;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: MessagingService.instance.subscriptionRef(subscriptionName),
      builder: (v, r) => IconButton(
        onPressed: () async {
          await toggle(r);
        },
        icon: v == true ? onWidget : offWidget,
      ),
    );
  }
}
