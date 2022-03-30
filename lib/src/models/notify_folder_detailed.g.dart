// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_folder_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyFolderDetailed _$NotifyFolderDetailedFromJson(
        Map<String, dynamic> json) =>
    NotifyFolderDetailed(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      participantsCount: json['participantsCount'] as int,
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) =>
              NotifyNotificationQuick.fromJson(e as Map<String, dynamic>))
          .toList(),
      creator:
          NotifyUserQuick.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotifyFolderDetailedToJson(
        NotifyFolderDetailed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'participantsCount': instance.participantsCount,
      'notifications': instance.notifications.map((e) => e.toJson()).toList(),
      'creator': instance.creator.toJson(),
    };
