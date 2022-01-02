import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/notify_folder_item.dart';
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

  final ScrollController _controller = ScrollController(keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverStickyHeader(
              header: AppBar(
                title: const Text('Today tasks'),
              ),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverFixedExtentList(
                  itemExtent: 56,
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => NotifyNotificationItem(
                      title: "Title #$i",
                      priority: i == 0,
                      datetime: DateTime.now(),
                      onTap: () => _controller.jumpTo(56 * 6),
                    ),
                    childCount: 6,
                  ),
                ),
              ),
            ),
            SliverStickyHeader(
              header: AppBar(
                title: const Text('Folders'),
              ),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverFixedExtentList(
                  itemExtent: 82,
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: NotifyFolderItem(
                        header: 'Header $i',
                        countNotifications: i,
                        subtitle: 'subtitle',
                        onTap: () {},
                      ),
                    ),
                    childCount: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
