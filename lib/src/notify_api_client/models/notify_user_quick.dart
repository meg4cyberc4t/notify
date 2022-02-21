import 'dart:convert';

import 'package:flutter/material.dart';

class NotifyUserQuick {
  const NotifyUserQuick({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.color,
  });
  static NotifyUserQuick fromJson(Map<String, dynamic> json) => NotifyUserQuick(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        color: Color(json['color']),
      );

  String toJson() => jsonEncode({
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'color': color.value,
      });

  final String id;
  final String firstname;
  final String lastname;
  final Color color;
}
