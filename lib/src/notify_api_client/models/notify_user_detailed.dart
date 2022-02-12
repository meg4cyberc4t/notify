import 'dart:convert';

import 'package:flutter/material.dart';

class NotifyUserDetailed {
  const NotifyUserDetailed({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.color,
    required this.subscriptionsCount,
    required this.subscribersCount,
  });
  static NotifyUserDetailed fromJson(Map<String, dynamic> json) =>
      NotifyUserDetailed(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        color: Color(json['color']),
        subscribersCount: json['subscribersCount'],
        subscriptionsCount: json['subscriptionsCount'],
      );

  String toJson() => jsonEncode({
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'color': color.value,
        'subscribersCount': subscribersCount,
        'subscriptionsCount': subscriptionsCount,
      });

  final String id;
  final String firstname;
  final String lastname;
  final Color color;
  final int subscriptionsCount;
  final int subscribersCount;
}
