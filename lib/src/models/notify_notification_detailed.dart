import 'package:json_annotation/json_annotation.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/settings/api_service/converters/repeat_mode_serialiser.dart';

part 'notify_notification_detailed.g.dart';

@JsonSerializable()
class NotifyNotificationDetailed {
  const NotifyNotificationDetailed({
    required this.id,
    required this.title,
    required this.description,
    required this.repeatMode,
    required this.important,
    required this.deadline,
    required this.creator,
    required this.uniqueClaim,
    required this.participantsCount,
  });

  factory NotifyNotificationDetailed.fromJson(Map<String, dynamic> json) =>
      _$NotifyNotificationDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyNotificationDetailedToJson(this);

  final String id;
  final String title;
  final String description;
  @RepeatModeSerialiser()
  final RepeatMode repeatMode;
  final bool important;
  final DateTime deadline;
  final NotifyUserQuick creator;
  final int uniqueClaim;
  final int participantsCount;
}
