// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_user_detailed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyUserDetailed _$NotifyUserDetailedFromJson(Map<String, dynamic> json) =>
    NotifyUserDetailed(
      id: json['id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      status: json['status'] as String,
      color: const ColorSerialiser().fromJson(json['color'] as int),
      subscriptionsCount: json['subscriptionsCount'] as int,
      subscribersCount: json['subscribersCount'] as int,
      follow: json['follow'] as bool,
      itsMe: json['itsMe'] as bool,
    );

Map<String, dynamic> _$NotifyUserDetailedToJson(NotifyUserDetailed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'status': instance.status,
      'color': const ColorSerialiser().toJson(instance.color),
      'subscriptionsCount': instance.subscriptionsCount,
      'subscribersCount': instance.subscribersCount,
      'follow': instance.follow,
      'itsMe': instance.itsMe,
    };
