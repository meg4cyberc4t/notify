import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<T?> showRepeatItBottomSheet<T>(
  final BuildContext context,
  final int value,
) async {
  final List<Map<String, String>> items = <Map<String, String>>[
    <String, String>{
      'title': 'One-time',
      'description': 'We will remind you of the reminder only once'
    },
    <String, String>{
      'title': 'Everyday',
      'description': 'We will remind you at the specified time'
    },
    <String, String>{
      'title': 'Everyweek',
      'description': 'We will remind you at the specified'
          ' time and day of the week'
    },
    <String, String>{
      'title': 'Everymonth',
      'description': 'Remind yourself of this in the coming months'
    },
    <String, String>{
      'title': 'Everyyear',
      'description': 'Reminder once a year!'
    }
  ];
  final List<Widget> children = <Widget>[];
  for (int i = 0; i < items.length; i++) {
    children.add(
      CheckboxListTile(
        value: value == i,
        title: Text(items[i]['title']!),
        subtitle: Text(items[i]['description']!),
        onChanged: (final _) => Navigator.of(context).pop(i),
      ),
    );
  }

  final double ratio = 400 / MediaQuery.of(context).size.height;
  return showFlexibleBottomSheet<T>(
    minHeight: 0,
    initHeight: ratio,
    maxHeight: ratio,
    context: context,
    isDismissible: true,
    isCollapsible: true,
    isModal: true,
    anchors: <double>[0, ratio],
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
        child: ListView(
          controller: scrollController,
          children: children,
        ),
      ),
    ),
  );
}
