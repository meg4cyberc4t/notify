import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/pages/additional/notification/create_notification_view.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_notifications_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const routeName = 'home_view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeviewTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            Provider.of<UserNotificationsState>(context, listen: false).load(),
        child: Consumer<UserNotificationsState>(
            builder: (context, state, _) => ListView(
                  children: [
                    AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      titleTextStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      title: Text(
                          AppLocalizations.of(context)!.recentNotifications),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(CreateNotificationView.routeName),
                        )
                      ],
                    ),
                    ...state.notifications.map(
                      (e) => NotificationListTile(notification: e),
                    ),
                    // AppBar(
                    //   centerTitle: true,
                    //   backgroundColor: Colors.transparent,
                    //   elevation: 0,
                    //   titleTextStyle:
                    //       Theme.of(context).textTheme.titleLarge!.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //   title: const Text('Folders'),
                    //   actions: [
                    //     IconButton(
                    //       icon: const Icon(Icons.add),
                    //       onPressed: () {},
                    //     )
                    //   ],
                    // ),
                    // ...folders.map((e) => Padding(
                    //       padding: const EdgeInsets.all(4),
                    //       child: FolderListTile(
                    //         folder: e,
                    //         onTap: () async {},
                    //       ),
                    //     )),
                  ],
                )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Create notification',
        onPressed: () async =>
            Navigator.of(context).pushNamed(CreateNotificationView.routeName),
      ),
    );
  }
}
