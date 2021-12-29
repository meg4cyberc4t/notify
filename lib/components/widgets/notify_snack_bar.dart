import 'package:flutter/material.dart';
import 'package:notify/notify_theme.dart';

SnackBar notifySnackBar(String title, BuildContext context) => SnackBar(
      dismissDirection: DismissDirection.down,
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: NotifyTheme.of(context).backgroundColor),
      ),
    );
