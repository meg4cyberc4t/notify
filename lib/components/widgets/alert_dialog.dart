import 'package:flutter/material.dart';

class NotifyAlertDialogButtonItem {
  const NotifyAlertDialogButtonItem({
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;
}

class NotifyAlertDialog extends StatelessWidget {
  const NotifyAlertDialog({
    Key? key,
    required this.title,
    this.listButtons = const <NotifyAlertDialogButtonItem>[],
  }) : super(key: key);

  final List<NotifyAlertDialogButtonItem> listButtons;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: listButtons
          .map((e) => TextButton(
                child: Text(e.title),
                onPressed: e.onPressed,
              ))
          .toList(),
    );
  }
}
