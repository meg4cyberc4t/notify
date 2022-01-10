// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_folder.dart';
import 'package:notify/services/classes/notify_item.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/static_methods/snapshot_middleware.dart';

class HomePage extends StatefulWidget {
  const HomePage({final Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed('/CreateNotificationPage'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverStickyHeader(
              header: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).backgroundColor,
                ),
                title: const Text('Today tasks'),
              ),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver: StreamBuilder<List<NotifyNotification>>(
                  stream:
                      FirebaseService.of(context).getMyNotificationsSnapshot(),
                  builder: (
                    final BuildContext context,
                    final AsyncSnapshot<List<NotifyNotification>> snapshot,
                  ) {
                    final Widget? widget = snapshotMiddleware(snapshot);
                    if (widget != null) {
                      return SliverToBoxAdapter(
                        child: SizedBox(height: 300, child: widget),
                      );
                    }
                    return SliverNotifyItemsList(
                      list: snapshot.data!,
                    );
                  },
                ),
              ),
            ),
            SliverStickyHeader(
              header: AppBar(
                title: const Text('Folders'),
              ),
              sliver: const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverNotifyItemsList(
                  divider: false,
                  list: <NotifyItem>[
                    NotifyFolder(
                      uid: '0',
                      title: 'Неприметным ковром',
                      description: 'стелется в тени цветов',
                      notifications: <NotifyNotification>[],
                    ),
                    NotifyFolder(
                      uid: '0',
                      title: 'репней и пестиков,',
                      description: 'шипов',
                      notifications: <NotifyNotification>[],
                    ),
                    NotifyFolder(
                      uid: '0',
                      title: 'Мы все исчезнем,',
                      description: 'но не мох',
                      notifications: <NotifyNotification>[],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
