import 'package:flutter/material.dart';

Future<T?> showExcludeDialog<T>({
  required BuildContext context,
  required String title,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: Text('Are you sure you want to exclude "$title"?'),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
