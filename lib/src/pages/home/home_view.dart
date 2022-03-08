import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/pages/additional/create_edit_notification_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const routeName = 'home_view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: LocalFutureBuilder(
          future: ApiService.notifications.get(),
          onData: (BuildContext context, List<NotifyNotificationQuick> list) {
            debugPrint(list.length.toString());
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  NotifyNotificationQuick ntf = list[index];
                  return ListTile(
                    title: Text(ntf.title),
                    subtitle: ntf.description.isNotEmpty
                        ? Text(ntf.description)
                        : null,
                    onTap: () {},
                  );
                });
          },
          onError: (BuildContext context, Object error) {
            return Text(error.toString());
          },
          onProgress: (BuildContext context) => const Center(
            child: Text('Progress'),
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
