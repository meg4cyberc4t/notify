// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notify/services/classes/notify_item.dart';

class NotifyUser implements NotifyItem {
  const NotifyUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.color,
  });

  NotifyUser.fromFirebaseDocumentSnapshot(
    final DocumentSnapshot<Map<String, dynamic>> data,
  )   : uid = data.id,
        firstName = data['first_name'],
        lastName = data['last_name'],
        status = data['status'],
        color = Color.fromRGBO(
          data['color_r'],
          data['color_g'],
          data['color_b'],
          1,
        );

  NotifyUser.fromJson(
    final Map<String, dynamic> json,
    this.uid,
  )   : firstName = json['first_name'],
        lastName = json['last_name'],
        status = json['status'],
        color = Color.fromRGBO(
          json['color_r'],
          json['color_g'],
          json['color_b'],
          1,
        );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'status': status,
        'color_r': colorR,
        'color_g': colorR,
        'color_b': colorR,
      };

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
