import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/screens/mainpage/profile/profilepage.dart';
import 'package:notify/services/notify_user.dart';

class NotifyUserListTile extends StatelessWidget {
  const NotifyUserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  final NotifyUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 10,
      leading: Avatar(
        color: user.color,
        title: user.avatarTitle,
        size: AvatarSize.mini,
      ),
      title: Text(
        user.firstName + " " + user.lastName,
      ),
      subtitle: user.status.isNotEmpty ? Text(user.status) : null,
      tileColor: Theme.of(context).backgroundColor,
      onTap: () => Navigator.push(
          context,
          Platform.isAndroid
              ? MaterialPageRoute(builder: (context) => ProfilePage(user.uid))
              : CupertinoPageRoute(
                  builder: (context) => ProfilePage(user.uid))),
    );
  }
}
