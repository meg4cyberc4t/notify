import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/components/view_models/folder_list_tile.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';

class ListFoldersView extends StatefulWidget {
  const ListFoldersView({
    Key? key,
    required this.title,
    required this.callback,
    this.onSelect,
  }) : super(key: key);

  static const String routeName = 'list_folders_view';

  final String title;
  final Future<List<NotifyFolderQuick>> Function() callback;
  final Function(NotifyFolderQuick e)? onSelect;

  @override
  State<ListFoldersView> createState() => _ListFoldersViewState();
}

class _ListFoldersViewState extends State<ListFoldersView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Consumer<CustomListViewLocalState>(
        builder: (context, _, __) =>
            LocalFutureBuilder<List<NotifyFolderQuick>>(
                future: widget.callback(),
                onError: (BuildContext context, Object error) {
                  debugPrint(error.toString());
                  return const Center(
                    child: Text('Error'),
                  );
                },
                onProgress: (BuildContext context) =>
                    const Center(child: CircularProgressIndicator()),
                onData:
                    (BuildContext context, List<NotifyFolderQuick> folders) {
                  if (folders.isEmpty) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off_outlined),
                            Text(
                              AppLocalizations.of(context)!.notFound,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) => LocalSplitter(
                      split: index == 0,
                      splitter: (Widget widget) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: widget,
                      ),
                      child: FolderListTile(
                        folder: folders[index],
                        onTap: widget.onSelect,
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
