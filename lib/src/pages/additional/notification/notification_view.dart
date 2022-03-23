import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/dialogs/show_delete_dialog.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_notification_detailed.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/pages/additional/notification/edit_notification_view.dart';
import 'package:notify/src/pages/additional/notification/notification_participants_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_notifications_state.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({
    Key? key,
    required this.id,
    this.cache,
  }) : super(key: key);

  static const routeName = 'notification_view';
  final String id;
  final NotifyNotificationQuick? cache;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    final String title =
        widget.cache?.title ?? AppLocalizations.of(context)!.notification;
    NotifyNotificationQuick? ntf = widget.cache;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer<NotificationViewLocalState>(
        builder: (context, value, child) => LocalFutureBuilder.withLoading(
          future: ApiService.notifications.getById(widget.id),
          onError: (BuildContext context, Object error) =>
              Center(child: Text(error.toString())),
          onLoading: (BuildContext context,
              NotifyNotificationDetailed? notification, bool isLoaded) {
            if (notification != null) ntf = notification.toQuick;
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: NotificationListTile(
                          notification: notification?.toQuick),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        DateFormat('HH:mm').format(
                                            notification?.deadline ??
                                                DateTime.now()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.time,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        DateFormat('dd.MM').format(
                                            notification?.deadline ??
                                                DateTime.now()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.date,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (notification == null) return;
                                await Navigator.of(context).pushNamed(
                                    NotificationParticipantsView.routeName,
                                    arguments: {
                                      'notification': notification,
                                    });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 60,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          notification?.participantsCount
                                                  .toString() ??
                                              '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .participants,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    UserListTile(
                      user: notification?.creator,
                      trailing: Text(
                        AppLocalizations.of(context)!.creator,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (notification == null) return;
                                showDeleteDialog(
                                        context: context,
                                        title: notification.title)
                                    .then((value) async {
                                  if (value != null && value) {
                                    await ApiService.notifications.delete(
                                        notification: notification.toQuick);
                                    Provider.of<UserNotificationsState>(context,
                                            listen: false)
                                        .load();

                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                          ),
                          if (RepeatMode.none != notification?.repeatMode)
                            const SizedBox(width: 8),
                          if (RepeatMode.none != notification?.repeatMode)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  if (notification == null) return;
                                  await ApiService.notifications.delete(
                                      notification: notification.toQuick);
                                  await ApiService.notifications.post(
                                    title: notification.title,
                                    description: notification.description,
                                    deadline: getRepeatModeNextDateTime(
                                        notification.deadline,
                                        notification.repeatMode),
                                    important: notification.important,
                                    repeatMode: notification.repeatMode,
                                  );
                                  Provider.of<UserNotificationsState>(context,
                                          listen: false)
                                      .load();

                                  Navigator.of(context).pop();
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.delay),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () async {
                  if (ntf == null) return;
                  await Navigator.of(context).pushNamed(
                      EditNotificationView.routeName,
                      arguments: {'notification': ntf!});
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
