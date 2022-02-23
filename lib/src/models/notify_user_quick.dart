import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/settings/api_service/converters/color_serialiser.dart';

part 'notify_user_quick.g.dart';

@JsonSerializable()
class NotifyUserQuick {
  const NotifyUserQuick({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.color,
  });

  factory NotifyUserQuick.fromJson(Map<String, dynamic> json) =>
      _$NotifyUserQuickFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyUserQuickToJson(this);

  String get title => '$firstname $lastname';

  final String id;
  final String firstname;
  final String lastname;
  @ColorSerialiser()
  final Color color;
}
