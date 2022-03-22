import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListNotificationsView extends StatefulWidget {
  const ListNotificationsView({
    Key? key,
    required this.title,
    required this.callback,
    this.onSelect,
  }) : super(key: key);

  static const String routeName = 'list_notifications_view';

  final String title;
  final Future<List<NotifyNotificationQuick>> Function() callback;
  final Function(NotifyNotificationQuick e)? onSelect;

  @override
  State<ListNotificationsView> createState() => _ListNotificationsViewState();
}

class _ListNotificationsViewState extends State<ListNotificationsView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: LocalFutureBuilder<List<NotifyNotificationQuick>>(
          future: widget.callback(),
          onError: (BuildContext context, Object error) {
            debugPrint(error.toString());
            return const Center(
              child: Text('Error'),
            );
          },
          onProgress: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
          onData: (BuildContext context, List<NotifyNotificationQuick> ntfs) {
            if (ntfs.isEmpty) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off_outlined),
                      Text(
                        AppLocalizations.of(context)!.notFound,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: ntfs.length,
              itemBuilder: (context, index) => LocalSplitter(
                split: index == 0,
                splitter: (Widget widget) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: widget,
                ),
                child: NotificationListTile(
                  notification: ntfs[index],
                  onTap: widget.onSelect,
                ),
              ),
            );
          }),
    );
  }
}
