import 'package:flutter/material.dart';
import 'package:notify/src/models/repeat_mode.dart';

Future<RepeatMode?> showRepeatItBottomSheet({
  required BuildContext context,
  RepeatMode value = RepeatMode.none,
}) async {
  return showModalBottomSheet<RepeatMode>(
    context: context,
    isDismissible: true,
    builder: (final BuildContext context) => Wrap(
      children: RepeatMode.values
          .map((e) => CheckboxListTile(
                value: e.index == RepeatMode.values.indexOf(value),
                title: Text(getRepeatModeTitle(context, e)),
                subtitle: Text(getRepeatModeDescription(context, e)),
                onChanged: e.index == RepeatMode.values.indexOf(value)
                    ? null
                    : (bool? value) {
                        return Navigator.of(context).pop(e);
                      },
              ))
          .toList(),
    ),
  );
}
