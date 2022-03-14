// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_user_quick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyUserQuick _$NotifyUserQuickFromJson(Map<String, dynamic> json) =>
    NotifyUserQuick(
      id: json['id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      color: const ColorSerialiser().fromJson(json['color'] as int),
      status: json['status'] as String,
    );

Map<String, dynamic> _$NotifyUserQuickToJson(NotifyUserQuick instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'status': instance.status,
      'color': const ColorSerialiser().toJson(instance.color),
    };
