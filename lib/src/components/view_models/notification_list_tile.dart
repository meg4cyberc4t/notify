import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/components/dialogs/show_delete_dialog.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/pages/additional/notification/notification_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';

class NotificationListTile extends StatefulWidget {
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
  State<NotificationListTile> createState() => _NotificationListTileState();
}

class _NotificationListTileState extends State<NotificationListTile> {
  @override
  Widget build(BuildContext context) {
    Function(NotifyNotificationQuick)? onTap = widget.onTap ??
        (NotifyNotificationQuick ntf) async {
          await Navigator.of(context).pushNamed<bool>(
              NotificationView.routeName,
              arguments: {'id': ntf.id, 'cache': ntf});
        };
    Function(NotifyNotificationQuick)? onLongPress = widget.onLongPress ??
        (NotifyNotificationQuick ntf) async {
          await showDeleteDialog(context: context, title: ntf.title)
              .then((value) async {
            if (value != null && value) {
              await ApiService.notifications.delete(notification: ntf);
              Provider.of<UserNotificationsState>(context, listen: false)
                  .load();
              Provider.of<UserFoldersState>(context, listen: false).load();
              Provider.of<CustomListViewLocalState>(context, listen: false)
                  .updateState();
            }
          });
        };

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

    final enabled = widget.notification != null &&
        DateTime.now().isBefore(widget.notification!.deadline);
    final disabledColor = Theme.of(context).hintColor;
    final leadingColor = widget.notification == null
        ? Theme.of(context).hintColor
        : widget.notification!.important
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
    if ((widget.notification?.description ??
            AppLocalizations.of(context)!.loading)
        .isNotEmpty) {
      subtitle = LocalSplitter.withShimmer(
        isLoading: widget.notification == null,
        context: context,
        child: Text(
          widget.notification?.description ??
              AppLocalizations.of(context)!.loading,
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
      isLoading: widget.notification == null,
      child: Text(
        widget.notification?.title ?? AppLocalizations.of(context)!.loading,
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
    if (widget.notification != null) {
      trailing = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeLeftString(widget.notification!.deadline),
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          Text(
            getRepeatModeTitle(context, widget.notification!.repeatMode),
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
        if (widget.notification == null) return;
        onTap(widget.notification!);
      },
      onLongPress: () {
        if (widget.notification == null) return;
        onLongPress(widget.notification!);
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
