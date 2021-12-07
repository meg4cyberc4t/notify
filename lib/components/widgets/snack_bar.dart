import 'package:flutter/material.dart';

SnackBar notifySnackBar(String title, BuildContext context) => SnackBar(
      dismissDirection: DismissDirection.down,
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: Theme.of(context).textTheme.button!.color),
      ),
    );
