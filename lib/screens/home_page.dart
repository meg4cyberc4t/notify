// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:notify/components/builders/custom_future_builder.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({final Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed('/CreateNotificationPage'),
      ),
      appBar: AppBar(
        title: const Text('Today tasks'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver:
                    CustomFutureBuilder<List<NotifyNotification>>.notifySliver(
                  future: FirebaseService.of(context)
                      .getNotificationsAboutDate(DateTime.now()),
                  onData: (
                    final BuildContext context,
                    final List<NotifyNotification> data,
                  ) =>
                      SliverNotifyItemsList(
                    list: data,
                  ),
                ),
              ),
              // SliverStickyHeader(
              //   header: AppBar(
              //     title: const Text('Folders'),
              //   ),
              //   sliver: const SliverPadding(
              //     padding: EdgeInsets.symmetric(vertical: 10),
              //     sliver: SliverNotifyItemsList(
              //       divider: false,
              //       list: <NotifyItem>[
              //         NotifyFolder(
              //           uid: '0',
              //           title: 'Неприметным ковром',
              //           description: 'стелется в тени цветов',
              //           notifications: <NotifyNotification>[],
              //         ),
              //         NotifyFolder(
              //           uid: '0',
              //           title: 'репней и пестиков,',
              //           description: 'шипов',
              //           notifications: <NotifyNotification>[],
              //         ),
              //         NotifyFolder(
              //           uid: '0',
              //           title: 'Мы все исчезнем,',
              //           description: 'но не мох',
              //           notifications: <NotifyNotification>[],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
