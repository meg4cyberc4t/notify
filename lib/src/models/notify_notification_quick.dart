import 'package:json_annotation/json_annotation.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/settings/api_service/converters/datetime_serialiser.dart';
import 'package:notify/src/settings/api_service/converters/repeat_mode_serialiser.dart';
part 'notify_notification_quick.g.dart';

@JsonSerializable()
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

  factory NotifyNotificationQuick.fromJson(Map<String, dynamic> json) =>
      _$NotifyNotificationQuickFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyNotificationQuickToJson(this);

  final String id;
  final String title;
  final String description;
  @RepeatModeSerialiser()
  final RepeatMode repeatMode;
  final bool important;
  @DateTimeSerialiser()
  final DateTime deadline;
  final NotifyUserQuick creator;
  final int uniqueClaim;
}
