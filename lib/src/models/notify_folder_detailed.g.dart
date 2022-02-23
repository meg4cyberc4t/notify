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
      notificationsCount: json['notificationsCount'] as int,
    );

Map<String, dynamic> _$NotifyFolderDetailedToJson(
        NotifyFolderDetailed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'participantsCount': instance.participantsCount,
      'notificationsCount': instance.notificationsCount,
    };
