import 'package:flutter/material.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user}) : super(key: key);
  final NotifyUserQuick? user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (user == null) return;
        Navigator.of(context).pushNamed(ProfileView.routeName, arguments: {
          'id': user!.id,
          'preTitle': user!.title,
        });
      },
      leading: LocalSplitter.withShimmer(
        context: context,
        isLoading: user == null,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            color: user?.color ?? Colors.grey,
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
