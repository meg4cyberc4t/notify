// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/methods/custom_route.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/screens/mainpage/profile/profilepage.dart';
import 'package:notify/services/notify_user.dart';

class NotifyUserListTile extends StatelessWidget {
  const NotifyUserListTile({required final this.user, final Key? key})
      : super(key: key);
  final NotifyUser user;

  @override
  Widget build(final BuildContext context) => ListTile(
        leading: NotifyAvatar(
          color: user.color,
          title: user.avatarTitle,
          size: AvatarSize.mini,
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(
          user.status.isNotEmpty ? user.status : '...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        tileColor: Theme.of(context).backgroundColor,
        onTap: () => Navigator.push(
          context,
          customRoute(
            ProfilePage(uid: user.uid),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NotifyUser>('user', user));
  }
}
