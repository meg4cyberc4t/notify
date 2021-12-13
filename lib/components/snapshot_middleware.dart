import 'package:flutter/material.dart';
import 'package:notify/components/widgets/progress_indicator.dart';

Widget? snapshotMiddleware(AsyncSnapshot snapshot) {
  if (snapshot.hasError) {
    return SizedBox.expand(
      child: Center(
        child: Text(snapshot.error.toString()),
      ),
    );
  } else if (!snapshot.hasData) {
    return const NotifyProgressIndicator();
  }
}

Widget? checkSnapshotDataExist(AsyncSnapshot snapshot) {
  if (!snapshot.data!.exists) {
    return const SizedBox.expand(
      child: Center(
        child: Text("Data does not exist"),
      ),
    );
  }
}
