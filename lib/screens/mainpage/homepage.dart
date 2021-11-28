import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notify/components/widgets/folder_item.dart';
import 'package:notify/components/widgets/notification_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            titleTextStyle: Theme.of(context).textTheme.headline3,
            title: const Text('Home'),
            centerTitle: false,
          ),
          SliverStickyHeader(
            header: miniHeader(
              context,
              'Today Tasks',
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => NotificationItem(
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
            header: miniHeader(context, 'Folders'),
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
    );
  }

  AppBar miniHeader(BuildContext context, String title) {
    return AppBar(
      elevation: 1,
      shadowColor: Colors.grey[300],
      backgroundColor: Theme.of(context).backgroundColor,
      titleSpacing: 0,
      primary: true,
      title: Text(title, style: Theme.of(context).textTheme.headline4),
    );
  }
}
