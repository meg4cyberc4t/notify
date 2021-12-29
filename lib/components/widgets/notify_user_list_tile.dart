import 'package:flutter/material.dart';
import 'package:notify/components/methods/custom_route.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/notify_theme.dart';
import 'package:notify/screens/mainpage/profile/profilepage.dart';
import 'package:notify/services/notify_user.dart';

class NotifyUserListTile extends StatelessWidget {
  const NotifyUserListTile({Key? key, required this.user}) : super(key: key);
  final NotifyUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: NotifyAvatar(
          color: user.color,
          title: user.avatarTitle,
          size: AvatarSize.mini,
        ),
        title: Text(user.firstName + " " + user.lastName),
        subtitle: Text(
          user.status.isNotEmpty ? user.status : "...",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: false,
        tileColor: NotifyTheme.of(context).backgroundColor,
        onTap: () =>
            Navigator.push(context, customRoute(ProfilePage(uid: user.uid))));
  }
}
