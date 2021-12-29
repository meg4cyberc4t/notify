import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/notify_folder_item.dart';
import 'package:notify/components/widgets/mini_sliver_header.dart';
import 'package:notify/components/widgets/notify_notification_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppBar(
                elevation: 0,
                shadowColor: Colors.grey[300],
                titleSpacing: 0,
                centerTitle: true,
                primary: false,
                title: const Text('Home'),
                backgroundColor: Theme.of(context).backgroundColor,
                titleTextStyle: Theme.of(context).textTheme.headline3,
              ),
            ),
            SliverStickyHeader(
              header: miniSliverHeader(
                context,
                'Today Tasks',
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => NotifyNotificationItem(
                    title: "Title #$i",
                    priority: i == 0,
                    datetime: DateTime.now(),
                    subtitle: i % 2 == 0 ? 'subtitle' : null,
                    onTap: () {},
                  ),
                  childCount: 4,
                ),
              ),
            ),
            SliverStickyHeader(
              header: miniSliverHeader(context, 'Folders'),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => NotifyFolderItem(
                    header: 'Header $i',
                    countNotifications: i,
                    subtitle: 'subtitle',
                    onTap: () {},
                  ),
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
