import 'package:flutter/material.dart';

AppBar miniSliverHeader(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    shadowColor: Colors.grey[300],
    backgroundColor: Theme.of(context).backgroundColor,
    titleSpacing: 0,
    centerTitle: true,
    primary: false,
    title: Text(title),
    titleTextStyle: Theme.of(context).textTheme.headline4,
  );
}
