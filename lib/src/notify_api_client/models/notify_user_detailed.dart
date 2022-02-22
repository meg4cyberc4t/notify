import 'dart:convert';

import 'package:flutter/material.dart';

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
  });
  static NotifyUserDetailed fromJson(Map<String, dynamic> json) =>
      NotifyUserDetailed(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        status: json['status'],
        color: Color(json['color']),
        subscribersCount: json['subscribersCount'],
        subscriptionsCount: json['subscriptionsCount'],
        follow: json['follow'],
      );

  String toJson() => jsonEncode({
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'color': color.value,
        'status': status,
        'subscribersCount': subscribersCount,
        'subscriptionsCount': subscriptionsCount,
        'follow': follow,
      });

  final String id;
  final String firstname;
  final String lastname;
  final String status;
  final Color color;
  final int subscriptionsCount;
  final int subscribersCount;
  final bool follow;
}
