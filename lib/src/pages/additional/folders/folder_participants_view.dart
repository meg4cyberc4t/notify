import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/dialogs/show_exclude_dialog.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_folder_detailed.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';

class FolderParticipantsView extends StatefulWidget {
  const FolderParticipantsView({
    Key? key,
    required this.folder,
  }) : super(key: key);

  static const String routeName = 'folder_participants_view';

  final NotifyFolderDetailed folder;

  @override
  State<FolderParticipantsView> createState() => _FolderParticipantsViewState();
}

class _FolderParticipantsViewState extends State<FolderParticipantsView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.participants),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(ListUsersView.routeName, arguments: {
              'title': AppLocalizations.of(context)!.sendInvation,
              'callback': () async {
                final List<NotifyUserQuick> candidates =
                    await ApiService.user.subscribers();
                return candidates.toList();
              },
              'onSelect': (NotifyUserQuick user) async {
                try {
                  await ApiService.folders.invite(
                    uuid: widget.folder.id,
                    inviteUserId: user.id,
                  );
                  Provider.of<FolderParticipantsLocalState>(context,
                          listen: false)
                      .updateState();
                  Provider.of<FolderViewLocalState>(context, listen: false)
                      .updateState();
                  Navigator.of(context).pop();
                } on ApiServiceException catch (e) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              }
            }),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<FolderParticipantsLocalState>(
        builder: (context, value, child) =>
            LocalFutureBuilder<List<NotifyUserQuick>>(
          future: ApiService.folders.byIdParticipants(uuid: widget.folder.id),
          onProgress: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
          onData: (BuildContext context, List<NotifyUserQuick> users) =>
              ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => UserListTile(
              user: users[index],
              onTap: (NotifyUserQuick user) async {
                final bool? result = await showExcludeDialog(
                    context: context, title: user.title);
                if (result != null && result) {
                  try {
                    await ApiService.folders.exclude(
                      uuid: widget.folder.id,
                      excludeUserId: user.id,
                    );
                    Provider.of<FolderParticipantsLocalState>(context,
                            listen: false)
                        .updateState();
                    Provider.of<FolderViewLocalState>(context, listen: false)
                        .updateState();
                  } on ApiServiceException catch (e) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.message)));
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
