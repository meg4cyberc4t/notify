import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:notify/src/settings/api_service/converters/color_serialiser.dart';

part 'notify_user_detailed.g.dart';

@JsonSerializable()
class NotifyUserDetailed {
  const NotifyUserDetailed({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.status,
    required this.color,
    required this.subscriptionsCount,
    required this.subscribersCount,
    required this.follow,
    required this.itsMe,
  });

  factory NotifyUserDetailed.fromJson(Map<String, dynamic> json) =>
      _$NotifyUserDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyUserDetailedToJson(this);

  String get title => '$firstname $lastname';

  String get shortTitle => (firstname[0] + lastname[0]).toUpperCase().trim();

  final String id;
  final String firstname;
  final String lastname;
  final String status;
  @ColorSerialiser()
  final Color color;
  final int subscriptionsCount;
  final int subscribersCount;
  final bool follow;
  final bool itsMe;
}
