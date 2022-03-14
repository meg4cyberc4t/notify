// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify/services/classes/notify_item.dart';
import 'package:notify/services/classes/notify_notification.dart';

class NotifyFolder implements NotifyItem {
  const NotifyFolder({
    required this.uid,
    required this.title,
    required this.description,
    required this.notifications,
  });

  NotifyFolder.fromFirebaseDocumentSnapshot(
    final DocumentSnapshot<Map<String, dynamic>> data,
  )   : uid = data.id,
        title = data['title'],
        description = data['description'],
        notifications = (data['notifications']
                as List<DocumentSnapshot<Map<String, dynamic>>>)
            .map(
              (final DocumentSnapshot<Map<String, dynamic>> e) =>
                  NotifyNotification.fromFirebaseDocumentSnapshot(e),
            )
            .toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'notifications': notifications,
      };

  final String uid;
  final String title;
  final String description;
  final List<NotifyNotification> notifications;
}
