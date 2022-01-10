// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:notify/services/notify_parameters.dart';

/// Custom middleware in [FutureBuilder] and [StreamBuilder],
/// which shows the expected widgets when an error or loading occurs
Widget? snapshotMiddleware(final AsyncSnapshot<dynamic> snapshot) {
  if (snapshot.hasError) {
    return SizedBox.expand(
      child: Center(
        child: Text(snapshot.error.toString()),
      ),
    );
  } else if (!snapshot.hasData || snapshot.data == null) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: NotifyParameters.circularProgressIndicatorWidth,
      ),
    );
  }
}
