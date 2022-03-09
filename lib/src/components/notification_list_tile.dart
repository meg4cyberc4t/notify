import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/models/notify_notification_quick.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    required this.notification,
    required this.onTap,
    required this.onLongPress,
    Key? key,
  }) : super(key: key);
  final NotifyNotificationQuick notification;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  String timeLeftString(DateTime deadline) {
    final Duration difference = deadline.difference(DateTime.now());
    if (difference.inDays >= 1) {
      return DateFormat('dd.MM').format(deadline);
    }
    if (difference.abs().inHours <= 1) {
      if (difference.isNegative) {
        return '${-difference.inMinutes}m passed';
      } else {
        return '${difference.inMinutes}m left';
      }
    }
    return DateFormat('HH:mm').format(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ListTile(
        title: Text(notification.title),
        subtitle: notification.description.isNotEmpty
            ? Text(notification.description)
            : null,
        enabled: DateTime.now().isBefore(notification.deadline),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeLeftString(notification.deadline),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
