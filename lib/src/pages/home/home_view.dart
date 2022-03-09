import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/notification_list_tile.dart';
import 'package:notify/src/components/show_delete_dialog.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/pages/additional/create_edit_notification_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const routeName = 'home_view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications today'),
        ),
        body: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: LocalFutureBuilder(
            future: ApiService.notifications.get(),
            onData: (BuildContext context, List<NotifyNotificationQuick> list) {
              list.sort((a, b) => b.deadline.compareTo(a.deadline));
              final ntfs = list.where(
                  (element) => element.deadline.day == DateTime.now().day);
              if (ntfs.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Text('There are no reminders today'),
                  ),
                );
              }
              return ListView(
                children: ntfs
                    .map(
                      (e) => NotificationListTile(
                          notification: e,
                          onTap: () {},
                          onLongPress: () async {
                            showDeleteDialog(context: context, title: e.title)
                                .then((value) async {
                              if (value != null && value) {
                                await ApiService.notifications
                                    .delete(uuid: e.id);
                                setState(() {});
                              }
                            });
                          }),
                    )
                    .toList(),
              );
            },
            onError: (BuildContext context, Object error) {
              return Text(error.toString());
            },
            onProgress: (BuildContext context) => const Center(
              child: Text('Progress'),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Create notification',
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                CreateEditNotificationView.routeNameCreateNotification,
              );
              setState(() {});
            }));
  }
}
