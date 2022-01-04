// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/screens/profile_page.dart';
import 'package:notify/services/classes/notify_item.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/static_methods/custom_route.dart';

class NotifyItemsList extends StatelessWidget {
  const NotifyItemsList({
    required final this.list,
    final Key? key,
    final this.controller,
  }) : super(key: key);
  final List<NotifyItem> list;
  final ScrollController? controller;
  @override
  Widget build(final BuildContext context) {
    if (list.isEmpty) {
      return ListView(
        controller: controller,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Text(
                'Users not found',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      controller: controller,
      itemCount: list.length,
      separatorBuilder: (
        final BuildContext context,
        final int index,
      ) =>
          const Divider(
        height: 1,
        indent: 80,
      ),
      itemBuilder: (
        final BuildContext context,
        final int index,
      ) {
        final NotifyItem item = list[index];
        if (item is NotifyUser) {
          final NotifyUser user = item;
          return NotifyUserListTile(
            key: Key(user.uid),
            user: user,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<NotifyItem>('list', list))
      ..add(DiagnosticsProperty<ScrollController?>('controller', controller));
  }
}

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
