// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notify/services/classes/notify_item.dart';
import 'package:provider/provider.dart';

class NotifyUser implements NotifyItem {
  NotifyUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.color,
    required this.notificationIds,
  }) : super();

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
        ),
        notificationIds =
            (data['notification_ids'] as List<dynamic>).cast<String>();

  static NotifyUser of(final BuildContext context) =>
      Provider.of<NotifyUser>(context);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'status': status,
        'color_r': colorR,
        'color_g': colorR,
        'color_b': colorR,
        'notification_ids': notificationIds,
      };

  final String uid;
  final String firstName;
  final String lastName;
  final String status;
  final Color color;
  final List<String> notificationIds;
  int get colorR => color.red;
  int get colorG => color.green;
  int get colorB => color.blue;
  String get avatarTitle => (firstName[0] + lastName[0]).toUpperCase();
}
