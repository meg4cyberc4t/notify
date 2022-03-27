import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class UserNotificationsState extends ChangeNotifier {
  List<NotifyNotificationQuick> _notifications = [];
  UserNotificationsState();

  void load() async {
    _notifications = await ApiService.notifications.get();
    _notifications.sort((a, b) => b.deadline.compareTo(a.deadline));

    notifyListeners();
  }

  UnmodifiableListView<NotifyNotificationQuick> get notifications =>
      UnmodifiableListView(_notifications);
}
