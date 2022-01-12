import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_item.dart';

/// [showFlexibleBottomSheet] is called, to which a list of user IDs is passed,
/// and a list of ready-made NotifyUser is returned in the widget view for the
/// user.
Future<T?> showNotifyItemsBottomSheet<T>(
  final BuildContext context,
  final List<NotifyItem> list,
) async =>
    showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      isDismissible: true,
      isCollapsible: true,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: NotifyItemsList(
              controller: scrollController,
              list: list,
            ),
          ),
        ),
      ),
      anchors: <double>[0, 0.5, 1],
    );
