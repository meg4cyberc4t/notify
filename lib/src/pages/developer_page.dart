import 'package:flutter/material.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';

// TODO: This page should not be in the stable version!
class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  static const routeName = 'developer_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandbox'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            const NotificationListTile(notification: null),
      ),
    );
  }
}
