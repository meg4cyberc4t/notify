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
  get colorR => color.red;
  get colorG => color.green;
  get colorB => color.blue;
  get avatarTitle => (firstName[0] + lastName[0]).toUpperCase();
}
