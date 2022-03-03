// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_notification_quick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyNotificationQuick _$NotifyNotificationQuickFromJson(
        Map<String, dynamic> json) =>
    NotifyNotificationQuick(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      repeatMode:
          const RepeatModeSerialiser().fromJson(json['repeatMode'] as int),
      important: json['important'] as bool,
      deadline: DateTime.parse(json['deadline'] as String),
      creator:
          NotifyUserQuick.fromJson(json['creator'] as Map<String, dynamic>),
      uniqueClaim: json['uniqueClaim'] as int,
    );

Map<String, dynamic> _$NotifyNotificationQuickToJson(
        NotifyNotificationQuick instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'repeatMode': const RepeatModeSerialiser().toJson(instance.repeatMode),
      'important': instance.important,
      'deadline': instance.deadline.toIso8601String(),
      'creator': instance.creator,
      'uniqueClaim': instance.uniqueClaim,
    };
