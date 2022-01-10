// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notify/services/classes/notify_item.dart';

class NotifyNotification implements NotifyItem {
  const NotifyNotification({
    required this.uid,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.repeat,
    required this.owner,
  });

  NotifyNotification.fromFirebaseDocumentSnapshot(
    final DocumentSnapshot<Map<String, dynamic>> data,
  )   : uid = data.id,
        title = data['title'],
        description = data['description'],
        deadline = (data['deadline'] as Timestamp).toDate(),
        priority = data['priority'],
        repeat = data['repeat'],
        owner = data['owner'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'description': description,
        'repeat': repeat,
        'deadline': deadline,
        'owner': owner,
        'priority': priority,
      };

  final String uid;
  final String title;
  final String owner;
  final bool priority;
  final int repeat;
  final String description;
  final DateTime deadline;
}
