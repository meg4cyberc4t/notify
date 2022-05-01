import 'package:flutter/material.dart';
import 'package:notify/src/components/dialogs/show_exclude_dialog.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_notification_detailed.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationParticipantsView extends StatefulWidget {
  const NotificationParticipantsView({
    Key? key,
    required this.notification,
  }) : super(key: key);

  static const String routeName = 'notification_participants_view';

  final NotifyNotificationDetailed notification;

  @override
  State<NotificationParticipantsView> createState() =>
      _NotificationParticipantsViewState();
}

class _NotificationParticipantsViewState
    extends State<NotificationParticipantsView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.participants),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(ListUsersView.routeName, arguments: {
              'title': AppLocalizations.of(context)!.sendInvation,
              'callback': () async {
                final List<NotifyUserQuick> candidates =
                    await ApiService.user.subscribers();
                return candidates.toList();
              },
              'onSelect': (NotifyUserQuick user) async {
                try {
                  await ApiService.notifications.invite(
                    uuid: widget.notification.id,
                    inviteUserId: user.id,
                  );
                  Provider.of<NotificationParticipantsLocalState>(context,
                          listen: false)
                      .updateState();
                  Provider.of<NotificationViewLocalState>(context,
                          listen: false)
                      .updateState();
                  Navigator.of(context).pop();
                } on ApiServiceException catch (e) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              }
            }),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<NotificationParticipantsLocalState>(
        builder: (context, value, child) =>
            LocalFutureBuilder<List<NotifyUserQuick>>(
          future: ApiService.notifications
              .byIdParticipants(uuid: widget.notification.id),
          onProgress: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
          onData: (BuildContext context, List<NotifyUserQuick> users) =>
              ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => UserListTile(
              user: users[index],
              onTap: (NotifyUserQuick user) async {
                final bool? result = await showExcludeDialog(
                    context: context, title: user.title);
                if (result != null && result) {
                  try {
                    await ApiService.notifications.exclude(
                      uuid: widget.notification.id,
                      excludeUserId: user.id,
                    );
                    Provider.of<NotificationParticipantsLocalState>(context,
                            listen: false)
                        .updateState();
                    Provider.of<NotificationViewLocalState>(context,
                            listen: false)
                        .updateState();
                  } on ApiServiceException catch (e) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.message)));
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
