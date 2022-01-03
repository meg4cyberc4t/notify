// ignore_for_file: public_member_api_docs, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/notify_folder_item.dart';
import 'package:notify/components/widgets/notify_notification_item.dart';
import 'package:notify/services/notifications_service.dart';

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
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverFixedExtentList(
                  itemExtent: 56,
                  delegate: SliverChildBuilderDelegate(
                    (final BuildContext context, final int i) =>
                        NotifyNotificationItem(
                      title: "Title #$i",
                      priority: i == 0,
                      datetime: DateTime.now(),
                      onPressed: () async {
                        await NotificationService().schedule(
                          title: "title",
                          body: "desc",
                          payload: 'payload',
                          dateTime:
                              DateTime.now().add(const Duration(seconds: 1)),
                        );
                      },
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
                    (final BuildContext context, final int i) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: NotifyFolderItem(
                        title: 'Header $i',
                        countNotifications: i,
                        subtitle: 'subtitle',
                        onPressed: () {},
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
