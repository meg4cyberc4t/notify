import 'package:flutter/material.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserListTile extends StatefulWidget {
  const UserListTile({
    Key? key,
    required this.user,
    this.trailing,
    this.onTap,
  }) : super(key: key);
  final NotifyUserQuick? user;
  final Widget? trailing;
  final Function(NotifyUserQuick user)? onTap;

  @override
  State<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  @override
  Widget build(BuildContext context) {
    Function(NotifyUserQuick user)? onTap = widget.onTap ??
        (NotifyUserQuick user) {
          Navigator.of(context).pushNamed(ProfileView.routeName, arguments: {
            'id': user.id,
            'preTitle': user.title,
          });
        };
    return ListTile(
      onTap: () {
        if (widget.user == null) return;
        onTap(widget.user!);
      },
      trailing: widget.trailing,
      leading: LocalSplitter.withShimmer(
        context: context,
        isLoading: widget.user == null,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            color: widget.user?.color ?? Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: widget.user != null
              ? Center(
                  child: Text(
                  widget.user!.shortTitle,
                  style: TextStyle(color: widget.user!.color.passive),
                ))
              : null,
          height: 40,
          width: 40,
        ),
      ),
      title: LocalSplitter.withShimmer(
        context: context,
        isLoading: widget.user == null,
        child:
            Text(widget.user?.title ?? AppLocalizations.of(context)!.loading),
      ),
      subtitle: Text(
        widget.user?.status ?? '...',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
