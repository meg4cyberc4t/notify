import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notifications_service.dart';

/// A method that will send absolutely all the notifications that the user has
Future<List<NotifyNotification>> getMyNotifications(
  final BuildContext context,
) async {
  final NotifyUser user = NotifyUser.of(context);
  await NotificationService().clearAllNotification();
  final List<NotifyNotification> ntfs = <NotifyNotification>[];
  for (final String id in user.notificationIds) {
    final DocumentSnapshot<NotifyNotification> doc =
        await FirebaseService.selectNotification(id).get();
    final NotifyNotification ntf = doc.data()!;
    ntfs.add(ntf);
    if (ntf.deadline.isAfter(DateTime.now())) {
      await NotificationService().schedule(ntf);
    }
  }
  ntfs.sort(
    (
      final NotifyNotification a,
      final NotifyNotification b,
    ) =>
        b.deadline.compareTo(a.deadline),
  );
  return ntfs;
}
