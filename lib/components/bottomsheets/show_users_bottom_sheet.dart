import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';

Future<T?> showUsersBottomSheet<T>(
    BuildContext context, List<String> userUids) async {
  List<NotifyUser> listUsers =
      await Provider.of<FirebaseService>(context, listen: false)
          .getUsersListFromUsersUidList(userUids);
  const double headerHeight = 25;
  return showStickyFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 1,
    context: context,
    maxHeaderHeight: headerHeight,
    minHeaderHeight: headerHeight,
    headerBuilder: (context, bottomSheetOffset) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
    ),
    bodyBuilder: (context, bottomSheetOffset) => SliverChildListDelegate(
      listUsers
          .map(
            (NotifyUser user) => ListTile(
              leading: Avatar(
                color: user.color,
                title: user.avatarTitle,
                size: AvatarSize.mini,
              ),
              title: Text(user.firstName + user.lastName),
              subtitle: Text(user.status),
              tileColor: Theme.of(context).backgroundColor,
              // onTap: () => ,
            ),
          )
          .toList(),
    ),
    anchors: [0, 0.5, 1],
  );
}
