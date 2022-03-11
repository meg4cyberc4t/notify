import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    required this.notification,
    this.onLongPress,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final NotifyNotificationQuick notification;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  String timeLeftString(DateTime deadline) {
    final Duration difference = deadline.difference(DateTime.now());
    if (difference.inDays >= 1) {
      return DateFormat('dd.MM').format(deadline);
    }
    if (difference.abs().inHours < 1) {
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
    final enabled = DateTime.now().isBefore(notification.deadline);
    final disabledColor = Theme.of(context).hintColor;
    final leadingColor = notification.important
        ? Colors.red
        : Theme.of(context).colorScheme.primary;
    final leading = Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        width: 3,
        height: 50,
        color: leadingColor.withOpacity(!enabled ? 0.5 : 1),
      ),
    );
    final subtitle = notification.description.isNotEmpty
        ? Text(
            notification.description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: enabled ? null : disabledColor),
            textAlign: TextAlign.start,
          )
        : null;
    final trailing = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeLeftString(notification.deadline),
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        Text(
          getRepeatModeTitle(context, notification.repeatMode),
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Theme.of(context).hintColor),
        ),
      ],
    );
    final title = Text(
      notification.title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: enabled ? null : disabledColor),
      textAlign: TextAlign.start,
    );
    const double leadingWidth = 16;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leading,
                const SizedBox(width: leadingWidth),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null) subtitle,
                  ],
                ),
              ],
            ),
            trailing,
          ],
          // enableFeedback: true,
        ),
      ),
    );
  }
}
