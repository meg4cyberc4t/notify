import 'dart:convert';

class NotifyFolderDetailed {
  const NotifyFolderDetailed({
    required this.id,
    required this.title,
    required this.description,
    required this.participantsCount,
    required this.notificationsCount,
  });
  static NotifyFolderDetailed fromJson(Map<String, dynamic> json) =>
      NotifyFolderDetailed(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        participantsCount: json['participantsCount'],
        notificationsCount: json['notificationsCount'],
      );

  String toJson() => jsonEncode({
        'id': id,
        'title': title,
        'description': description,
        'participantsCount': participantsCount,
        'notificationsCount': notificationsCount,
      });

  final String id;
  final String title;
  final String description;
  final int participantsCount;
  final int notificationsCount;
}
