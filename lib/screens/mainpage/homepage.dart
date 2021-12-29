import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/folder_item.dart';
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
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              titleTextStyle: Theme.of(context).textTheme.headline3,
              title: const Text('Home'),
              centerTitle: true,
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
                  (context, i) => FolderItem(
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
