import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/user_list_tile.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';

Future<T?> showUsersBottomSheet<T>(
    BuildContext context, List<String> userUids) async {
  return showFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: 1,
    context: context,
    isDismissible: true,
    isCollapsible: true,
    isExpand: userUids.isNotEmpty,
    isModal: true,
    builder: (context, scrollController, bottomSheetOffset) {
      return SafeArea(
        child: Material(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: StreamBuilder(
            stream: Provider.of<FirebaseService>(context, listen: false)
                .getUsersListFromUsersUidList(userUids),
            builder: (context, snapshot) {
              Widget? widget = snapshotMiddleware(snapshot);
              if (widget != null) {
                return widget;
              }
              List<NotifyUser> data = snapshot.data as List<NotifyUser>;
              if (data.isEmpty) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(
                        "Users not found",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView(
                  controller: scrollController,
                  children: (snapshot.data as List<NotifyUser>)
                      .map((NotifyUser user) => NotifyUserListTile(user: user))
                      .toList(),
                ),
              );
            },
          ),
        ),
      );
    },
    anchors: [0, 0.5, 1],
  );
}
