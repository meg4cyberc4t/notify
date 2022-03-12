import 'package:flutter/material.dart';
import 'package:notify/src/methods/get_passive_color.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/profile/profile_view.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.user}) : super(key: key);
  final NotifyUserQuick user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () =>
          Navigator.of(context).pushNamed(ProfileView.routeName, arguments: {
        'id': user.id,
        'preTitle': user.title,
      }),
      leading: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          color: user.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(
          user.shortTitle,
          style: TextStyle(color: getPassiveColor(user.color)),
        )),
        height: 40,
        width: 40,
      ),
      title: Text(user.title),
      subtitle: Text(
        user.status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
