import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/methods/snapshot_middleware.dart';
import 'package:notify/components/widgets/notify_user_list_tile.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';

/// [showFlexibleBottomSheet] is called, to which a list of user IDs is passed,
/// and a list of ready-made NotifyUser is returned in the widget view for the
/// user.
Future<T?> showUsersBottomSheet<T>(
  final BuildContext context,
  final List<String> userUids,
) async =>
    showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      isDismissible: true,
      isCollapsible: true,
      isExpand: userUids.isNotEmpty,
      isModal: true,
      builder: (
        final BuildContext context,
        final FlexibleDraggableScrollableSheetScrollController scrollController,
        final double bottomSheetOffset,
      ) =>
          SafeArea(
        child: Material(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: StreamBuilder<List<NotifyUser>>(
            stream: Provider.of<FirebaseService>(context, listen: false)
                .getUsersListFromUsersUidList(userUids),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<NotifyUser>> snapshot,
            ) {
              final Widget? widget = snapshotMiddleware(snapshot);
              if (widget != null) {
                return widget;
              }
              final List<NotifyUser> data = snapshot.data!;
              if (data.isEmpty) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(
                        'Users not found',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: data.length,
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
                  ) =>
                      NotifyUserListTile(user: data[index]),
                ),
              );
            },
          ),
        ),
      ),
      anchors: <double>[0, 0.5, 1],
    );
