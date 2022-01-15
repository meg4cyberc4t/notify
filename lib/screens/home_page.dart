// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:notify/components/builders/custom_stream_builder.dart';
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
        title: const Text('Tasks'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver:
                    CustomStreamBuilder<List<NotifyNotification>>.notifySliver(
                  stream: FirebaseService.getMyNotifications(),
                  onData: (
                    final BuildContext context,
                    final List<NotifyNotification> data,
                  ) =>
                      SliverNotifyItemsList(
                    list: data,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
