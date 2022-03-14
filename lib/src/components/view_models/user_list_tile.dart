import 'package:flutter/material.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserListTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Function(NotifyUserQuick user)? onPressed = onTap ??
        (NotifyUserQuick user) {
          Navigator.of(context).pushNamed(ProfileView.routeName, arguments: {
            'id': user.id,
            'preTitle': user.title,
          });
        };
    return ListTile(
      onTap: () {
        if (user == null) return;
        onPressed(user!);
      },
      trailing: trailing,
      leading: LocalSplitter.withShimmer(
        context: context,
        isLoading: user == null,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            color: user?.color ?? Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: user != null
              ? Center(
                  child: Text(
                  user!.shortTitle,
                  style: TextStyle(color: user!.color.passive),
                ))
              : null,
          height: 40,
          width: 40,
        ),
      ),
      title: LocalSplitter.withShimmer(
        context: context,
        isLoading: user == null,
        child: Text(user?.title ?? AppLocalizations.of(context)!.loading),
      ),
      subtitle: Text(
        user?.status ?? '...',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
