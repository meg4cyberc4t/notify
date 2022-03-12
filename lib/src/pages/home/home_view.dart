import 'package:flutter/material.dart';

import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/notification_list_tile.dart';
import 'package:notify/src/components/show_delete_dialog.dart';
import 'package:notify/src/models/notify_folder_detailed.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/pages/additional/notification/create_notification_view.dart';
import 'package:notify/src/pages/additional/notification/notification_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

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
          title: const Text('Home'),
        ),
        body: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: LocalFutureBuilder(
            onError: (BuildContext context, Object error) =>
                Text(error.toString()),
            future: () async {
              var ntfs = await ApiService.notifications.get();
              ntfs.sort((a, b) => b.deadline.compareTo(a.deadline));
              //  await ApiService.folders.get()
              return __SeparateVariable(
                folders: [],
                notifications: ntfs
                    .where(
                        (element) => element.deadline.day == DateTime.now().day)
                    .toList(),
              );
            }(),
            onProgress: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ),
            onData: (
              BuildContext context,
              __SeparateVariable vari,
            ) {
              final ntfs = vari.notifications;
              // final folders = vari.folders;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      titleTextStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      title: const Text('Today notifications'),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(CreateNotificationView.routeName)
                              .whenComplete(() => setState(() {})),
                        )
                      ],
                    ),
                    ...ntfs.map(
                      (e) => NotificationListTile(
                          notification: e,
                          onTap: () async {
                            await Navigator.of(context).pushNamed(
                                NotificationView.routeName,
                                arguments: {
                                  'id': e.id,
                                  'cache': e,
                                });
                            // final bool? value =
                            //     await Navigator.of(context).pushNamed<bool>(
                            //   EditNotificationView.routeName,
                            //   arguments: e.toJson(),
                            // );
                            // if (value != null && value == true) {
                            //   setState(() {});
                            // }
                          },
                          onLongPress: () async {
                            showDeleteDialog(context: context, title: e.title)
                                .then((value) async {
                              if (value != null && value) {
                                await ApiService.notifications
                                    .delete(uuid: e.id);
                                setState(() {});
                              }
                            });
                          }),
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
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Create notification',
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed(CreateNotificationView.routeName);
              setState(() {});
            }));
  }
}

class __SeparateVariable {
  const __SeparateVariable({
    required this.folders,
    required this.notifications,
  });
  final List<NotifyFolderDetailed> folders;
  final List<NotifyNotificationQuick> notifications;
}
