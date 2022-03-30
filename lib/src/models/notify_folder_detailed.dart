import 'package:json_annotation/json_annotation.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/notify_user_quick.dart';

part 'notify_folder_detailed.g.dart';

@JsonSerializable()
class NotifyFolderDetailed {
  const NotifyFolderDetailed({
    required this.id,
    required this.title,
    required this.description,
    required this.participantsCount,
    required this.notifications,
    required this.creator,
  });

  factory NotifyFolderDetailed.fromJson(Map<String, dynamic> json) =>
      _$NotifyFolderDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyFolderDetailedToJson(this);

  NotifyFolderQuick get toQuick {
    return NotifyFolderQuick(
      id: id,
      title: title,
      description: description,
      notificationsCount: notifications.length,
      participantsCount: participantsCount,
    );
  }

  final String id;
  final String title;
  final String description;
  final int participantsCount;
  final List<NotifyNotificationQuick> notifications;
  final NotifyUserQuick creator;
}
