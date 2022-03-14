import 'package:flutter/material.dart';

/// Branded Snack Bar Apps.
/// Can be called as:
/// ScaffoldMessenger.of(context).showSnackBar(notifySnackBar('name', context));
SnackBar notifySnackBar(final String title, final BuildContext context) =>
    SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .button!
            .copyWith(color: Theme.of(context).backgroundColor),
      ),
    );
