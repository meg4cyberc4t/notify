import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/dialogs/show_exclude_dialog.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/dialogs/show_delete_dialog.dart';
import 'package:notify/src/components/view_models/folder_list_tile.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_folder_detailed.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/pages/additional/folders/create_notification_in_folder_view.dart';
import 'package:notify/src/pages/additional/folders/folder_participants_view.dart';
import 'package:notify/src/pages/additional/list_notifications_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    Key? key,
    required this.id,
    this.cache,
  }) : super(key: key);

  static const routeName = 'folder_view';
  final String id;
  final NotifyFolderQuick? cache;

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  @override
  Widget build(BuildContext context) {
    final String title =
        widget.cache?.title ?? AppLocalizations.of(context)!.notification;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer<FolderViewLocalState>(
        builder: (context, value, child) => LocalFutureBuilder.withLoading(
          future: ApiService.folders.getById(widget.id),
          onError: (BuildContext context, Object error) =>
              Center(child: Text(error.toString())),
          onLoading: (BuildContext context, NotifyFolderDetailed? folder,
              bool isLoaded) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FolderListTile(
                        folder: folder?.toQuick,
                        onTap: (e) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (folder?.notifications.length ??
                                                widget.cache
                                                    ?.notificationsCount ??
                                                0)
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.notifications,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                if (folder == null) return;
                                await Navigator.of(context).pushNamed(
                                    FolderParticipantsView.routeName,
                                    arguments: {
                                      'folder': folder,
                                    });
                              },
                              child: SizedBox(
                                height: 60,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (folder?.participantsCount ??
                                                  widget.cache
                                                      ?.participantsCount ??
                                                  0)
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .participants,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onLongPress: () async {
                                if (folder == null) return;
                                await Navigator.of(context).pushNamed(
                                    ListNotificationsView.routeName,
                                    arguments: {
                                      'title': AppLocalizations.of(context)!
                                          .chooseNotification,
                                      'callback': ApiService.notifications.get,
                                      'onSelect':
                                          (NotifyNotificationQuick e) async {
                                        await ApiService.folders
                                            .addNotification(
                                          folderId: folder.id,
                                          ntfIds: [e.id],
                                        );
                                        Provider.of<FolderViewLocalState>(
                                                context,
                                                listen: false)
                                            .updateState();
                                        Provider.of<UserNotificationsState>(
                                                context,
                                                listen: false)
                                            .load();
                                        Provider.of<UserFoldersState>(context,
                                                listen: false)
                                            .load();
                                        Provider.of<CustomListViewLocalState>(
                                                context,
                                                listen: false)
                                            .updateState();
                                        Navigator.of(context).pop();
                                      }
                                    });
                              },
                              onTap: () async {
                                if (folder == null) return;
                                await Navigator.of(context).pushNamed(
                                    CreateNotificationInFolderView.routeName,
                                    arguments: {'folder': folder.toQuick});
                              },
                              child: SizedBox(
                                height: 60,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Center(
                                          child: Icon(
                                        Icons.notification_add_outlined,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.color,
                                      )),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.remind,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    UserListTile(
                      user: folder?.creator,
                      trailing: Text(
                        AppLocalizations.of(context)!.creator,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    if (folder != null)
                      ...folder.notifications.map(
                        (e) => NotificationListTile(
                          notification: e,
                          onTap: (e) async {
                            final bool? value = await showExcludeDialog(
                                context: context, title: e.title);
                            if (value != null && value) {
                              await ApiService.folders.removeNotification(
                                  folderId: widget.id, ntfIds: [e.id]);
                              Provider.of<FolderViewLocalState>(context,
                                      listen: false)
                                  .updateState();
                              Provider.of<UserFoldersState>(context,
                                      listen: false)
                                  .load();
                              Provider.of<CustomListViewLocalState>(context,
                                      listen: false)
                                  .updateState();
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (folder == null) return;
                                showDeleteDialog(
                                        context: context, title: folder.title)
                                    .then((value) async {
                                  if (value != null && value) {
                                    await ApiService.folders
                                        .delete(uuid: folder.id);
                                    Provider.of<UserFoldersState>(context,
                                            listen: false)
                                        .load();
                                    Provider.of<UserNotificationsState>(context,
                                            listen: false)
                                        .load();
                                    Provider.of<UserState>(context,
                                            listen: false)
                                        .load();
                                    Provider.of<CustomListViewLocalState>(
                                            context,
                                            listen: false)
                                        .updateState();
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
