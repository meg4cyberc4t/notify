// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class NotifyUser {
  const NotifyUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.color,
    required this.status,
  });
  final String uid;
  final String firstName;
  final String lastName;
  final String status;
  final Color color;
  int get colorR => color.red;
  int get colorG => color.green;
  int get colorB => color.blue;
  String get avatarTitle => (firstName[0] + lastName[0]).toUpperCase();
}
