import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class UserNotificationsState extends ChangeNotifier {
  UserNotificationsState();

  void load() async {
    _notifications = await ApiService.notifications.get();
    _notifications.sort((a, b) => b.deadline.compareTo(a.deadline));

    notifyListeners();
  }

  late List<NotifyNotificationQuick> _notifications;
  UnmodifiableListView<NotifyNotificationQuick> get notifications =>
      UnmodifiableListView(_notifications);
}
