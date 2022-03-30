// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_folder_quick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyFolderQuick _$NotifyFolderQuickFromJson(Map<String, dynamic> json) =>
    NotifyFolderQuick(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      participantsCount: json['participantsCount'] as int,
      notificationsCount: json['notificationsCount'] as int,
    );

Map<String, dynamic> _$NotifyFolderQuickToJson(NotifyFolderQuick instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'participantsCount': instance.participantsCount,
      'notificationsCount': instance.notificationsCount,
    };
