import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    required this.notification,
    this.onLongPress,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final NotifyNotificationQuick? notification;
  final Function(NotifyNotificationQuick)? onTap;
  final Function(NotifyNotificationQuick)? onLongPress;

  @override
  Widget build(BuildContext context) {
    String timeLeftString(DateTime deadline) {
      final Duration difference = deadline.difference(DateTime.now());
      if (difference.inDays >= 1) {
        return DateFormat('dd.MM').format(deadline);
      }
      if (difference.abs().inHours < 1) {
        if (difference.isNegative) {
          return AppLocalizations.of(context)!
              .minutesPassed(-difference.inMinutes);
        } else {
          return AppLocalizations.of(context)!
              .minutesLeft(difference.inMinutes);
        }
      }
      return DateFormat('HH:mm').format(deadline);
    }

    final enabled =
        notification != null && DateTime.now().isBefore(notification!.deadline);
    final disabledColor = Theme.of(context).hintColor;
    final leadingColor = notification == null
        ? Theme.of(context).hintColor
        : notification!.important
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
    Widget? subtitle;
    if ((notification?.description ?? AppLocalizations.of(context)!.loading)
        .isNotEmpty) {
      subtitle = LocalSplitter.withShimmer(
        isLoading: notification == null,
        context: context,
        child: Text(
          notification?.description ?? AppLocalizations.of(context)!.loading,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: enabled ? null : disabledColor),
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    final title = LocalSplitter.withShimmer(
      context: context,
      isLoading: notification == null,
      child: Text(
        notification?.title ?? AppLocalizations.of(context)!.loading,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: enabled ? null : disabledColor),
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    Widget trailing = const SizedBox();
    if (notification != null) {
      trailing = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeLeftString(notification!.deadline),
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          Text(
            getRepeatModeTitle(context, notification!.repeatMode),
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      );
    }

    const double leadingWidth = 16;
    return InkWell(
      onTap: () {
        if (notification == null) return;
        if (onTap != null) onTap!(notification!);
      },
      onLongPress: () {
        if (notification == null) return;
        if (onLongPress != null) onLongPress!(notification!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    leading,
                    const SizedBox(width: leadingWidth),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title,
                          if (subtitle != null) subtitle,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: leadingWidth),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
