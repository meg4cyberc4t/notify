import 'dart:convert';

import 'package:notify/src/notify_api_client/models/notify_user_quick.dart';
import 'package:notify/src/notify_api_client/models/repeat_mode.dart';

class NotifyNotificationQuick {
  const NotifyNotificationQuick({
    required this.id,
    required this.title,
    required this.description,
    required this.repeatMode,
    required this.important,
    required this.deadline,
    required this.creator,
    required this.uniqueClaim,
  });
  static NotifyNotificationQuick fromJson(Map<String, dynamic> json) =>
      NotifyNotificationQuick(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        repeatMode: RepeatMode.values[json['repeatMode']],
        important: json['important'],
        deadline: json['deadline'],
        creator: NotifyUserQuick.fromJson(json['creator']),
        uniqueClaim: json['uniqueClaim'],
      );

  String toJson() => jsonEncode({
        'id': id,
        'title': title,
        'description': description,
        'repeat_mode': repeatMode.index,
        'important': important,
        'deadline': deadline,
        'creator': creator.toJson(),
        'unique_claim': uniqueClaim,
      });

  final String id;
  final String title;
  final String description;
  final RepeatMode repeatMode;
  final bool important;
  final DateTime deadline;
  final NotifyUserQuick creator;
  final int uniqueClaim;
}
