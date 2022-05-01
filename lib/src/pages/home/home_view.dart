import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/view_models/folder_list_tile.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/pages/additional/folders/create_folder_view.dart';
import 'package:notify/src/pages/additional/notification/create_notification_view.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';

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
        onRefresh: () async {
          Provider.of<UserNotificationsState>(context, listen: false).load();
          Provider.of<UserFoldersState>(context, listen: false).load();
        },
        child: Consumer2<UserNotificationsState, UserFoldersState>(
            builder: (context, notificationsState, foldersState, _) => ListView(
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
                    if (notificationsState.notifications.isEmpty)
                      const SizedBox(height: 150),
                    ...notificationsState.notifications.map(
                      (e) => NotificationListTile(notification: e),
                    ),
                    AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      titleTextStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      title: Text(AppLocalizations.of(context)!.folders),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(CreateFolderView.routeName),
                        )
                      ],
                    ),
                    if (foldersState.folders.isEmpty)
                      const SizedBox(height: 150),
                    ...foldersState.folders
                        .map((e) => FolderListTile(folder: e)),
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
