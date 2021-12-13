import 'package:flutter/material.dart';

AppBar miniSliverHeader(BuildContext context, String title) {
  return AppBar(
    elevation: 1,
    shadowColor: Colors.grey[300],
    backgroundColor: Theme.of(context).backgroundColor,
    titleSpacing: 0,
    primary: false,
    title: Text(title, style: Theme.of(context).textTheme.headline4),
  );
}
