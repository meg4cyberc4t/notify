// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The unit of the button before NotifyAlertDialog
class NotifyAlertDialogButtonItem {
  const NotifyAlertDialogButtonItem({
    required this.title,
    required this.onPressed,
  });

  final String title;

  final VoidCallback onPressed;
}

/// The main [AlertDialog] in the application.
/// Accepts the Window title, as well as button instances
/// in the form [NotifyAlertDialogButtonItem]
class NotifyAlertDialog extends StatelessWidget {
  const NotifyAlertDialog({
    required this.title,
    final Key? key,
    this.buttons = const <NotifyAlertDialogButtonItem>[],
  }) : super(key: key);

  final List<NotifyAlertDialogButtonItem> buttons;
  final String title;
  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(title),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: buttons
            .map(
              (final NotifyAlertDialogButtonItem e) => TextButton(
                onPressed: e.onPressed,
                child: Text(e.title),
              ),
            )
            .toList(),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(
        IterableProperty<NotifyAlertDialogButtonItem>('buttons', buttons),
      );
  }
}
