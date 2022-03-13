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

  NotifyNotificationQuick copyWith({
    String? id,
    String? title,
    String? description,
    RepeatMode? repeatMode,
    bool? important,
    DateTime? deadline,
    NotifyUserQuick? creator,
    int? uniqueClaim,
  }) {
    return NotifyNotificationQuick(
      id: id ??= this.id,
      title: title ??= this.title,
      description: description ??= this.description,
      repeatMode: repeatMode ??= this.repeatMode,
      important: important ??= this.important,
      deadline: deadline ??= this.deadline,
      creator: creator ??= this.creator,
      uniqueClaim: uniqueClaim ??= this.uniqueClaim,
    );
  }

  factory NotifyNotificationQuick.fromJson(Map<String, dynamic> json) =>
      _$NotifyNotificationQuickFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyNotificationQuickToJson(this);

  String get payload => id;

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
