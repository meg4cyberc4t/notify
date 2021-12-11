import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/services/notify_user.dart';

Future<T?> showUsersBottomSheet<T>(
    BuildContext context, List<NotifyUser> users) {
  return showStickyFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 1,
    context: context,
    maxHeaderHeight: 0,
    minHeaderHeight: 0,
    headerBuilder: (context, bottomSheetOffset) => const SizedBox(),
    // headerBuilder: (context, bottomSheetOffset) => Container(
    //   height: 50,
    //   child: Text(
    //     title,
    //     style: Theme.of(context).textTheme.headline5,
    //   ),
    //   alignment: Alignment.center,
    //   color: Theme.of(context).backgroundColor,
    // ),
    bodyBuilder: (context, bottomSheetOffset) => SliverChildListDelegate(
      users
          .map((NotifyUser user) => ListTile(
                leading: Avatar(
                  color: user.color,
                  title: user.avatarTitle,
                  size: AvatarSize.mini,
                ),
                title: Text(user.firstName + user.lastName),
                subtitle: Text(user.status),
                tileColor: Theme.of(context).backgroundColor,
              ))
          .toList(),
    ),
    anchors: [0, 0.5, 1],
  );
}
