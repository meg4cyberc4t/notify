import 'package:flutter/material.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:notify/src/pages/additional/folders/folder_view.dart';

class FolderListTile extends StatefulWidget {
  const FolderListTile({
    required this.folder,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final NotifyFolderQuick? folder;
  final Function(NotifyFolderQuick folder)? onTap;

  @override
  State<FolderListTile> createState() => _FolderListTileState();
}

class _FolderListTileState extends State<FolderListTile> {
  static const leadingWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    Function(NotifyFolderQuick folder) onTap = widget.onTap ??
        (e) {
          Navigator.of(context).pushNamed(FolderView.routeName,
              arguments: {'id': e.id, 'cache': e});
        };

    final enabled =
        widget.folder != null && widget.folder!.notificationsCount > 0;
    final disabledColor = Theme.of(context).hintColor;

    Widget? subtitle;
    if ((widget.folder?.description ?? AppLocalizations.of(context)!.loading)
        .isNotEmpty) {
      subtitle = LocalSplitter.withShimmer(
        isLoading: widget.folder == null,
        context: context,
        child: Text(
          widget.folder?.description ?? AppLocalizations.of(context)!.loading,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: enabled ? null : disabledColor),
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    final title = LocalSplitter.withShimmer(
      context: context,
      isLoading: widget.folder == null,
      child: Text(
        widget.folder?.title ?? AppLocalizations.of(context)!.loading,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: enabled ? null : disabledColor),
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    final Widget trailing = Text(
      '${widget.folder?.notificationsCount ?? 0} ntf',
      style: TextStyle(color: Theme.of(context).hintColor),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: () {
            if (widget.folder == null) return;
            onTap(widget.folder!);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                  color: enabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).hintColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                title,
                                if (subtitle != null) subtitle,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: leadingWidth),
                    trailing,
                  ],
                ),
              ),
            ),
          )

          // title: Text(widget.folder.title ?? "Загрузка"),
          // subtitle: widget.folder.description.isNotEmpty
          //     ? Text(widget.folder.description)
          //     : null,
          // trailing: Text(
          //   '${widget.folder.notificationsCount} ntf',
          //   style: Theme.of(context).textTheme.subtitle1,
          // ),
          // minLeadingWidth: 0,
          ),
    );
  }
}
