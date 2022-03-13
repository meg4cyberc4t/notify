import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_notification_detailed.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/additional/notification/edit_notification_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

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
    final String title = widget.cache?.title ?? 'Notification';
    NotifyNotificationQuick? ntf = widget.cache;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: LocalFutureBuilder.withLoading(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateFormat('HH:mm').format(
                                          notification?.deadline ??
                                              DateTime.now()),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Время',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd.MM').format(
                                          notification?.deadline ??
                                              DateTime.now()),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Дата',
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                  ListUsersView.routeName,
                                  arguments: {
                                    'title': 'Участники',
                                    'callback': () => ApiService.notifications
                                        .byIdParticipants(
                                            uuid: notification.id),
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
                                    'Участники',
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
                  UserListTile(user: notification?.creator),
                  Text(
                    'Создатель',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () async {
                if (ntf == null) return;
                final bool? result = await Navigator.of(context).pushNamed(
                    EditNotificationView.routeName,
                    arguments: ntf!.toJson());
                if (result != null && result) setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
