// ignore_for_file: prefer_single_quotes

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// FlutterLocalNotificationsPlugin.instance
FlutterLocalNotificationsPlugin plug = FlutterLocalNotificationsPlugin();

/// The main service is a layer that is used for native and convenient
/// interaction with notifications in the application
class NotificationService {
  /// Factory constructor for interacting with only one instance of
  /// [NotificationService] throughout the application
  factory NotificationService() => _instance;
  const NotificationService._();
  static const NotificationService _instance = NotificationService._();

  /// File name for the logo in notifications
  static const String notificationsIcon = "logo";

  /// Initialization of all necessary settings for Android, iOS,
  /// obtaining permissions, setting location for time
  static Future<void> initializingSettings() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(NotificationService.notificationsIcon);
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _selectNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  /// Parameters of a single notification channel.
  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'notify_notifications',
      'notify_notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    ),
    iOS: IOSNotificationDetails(threadIdentifier: 'notify_notifications'),
  );

  static void _onDidReceiveLocalNotification(
    final int id,
    final String? title,
    final String? body,
    final String? payload,
  ) {
    debugPrint('Handle old notification!: $id, $title, $body, $payload');
  }

  static Future<void> _selectNotification(final String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> scheduleFromNotifyNotification(final NotifyNotification ntf) {
    debugPrint('Schedule: ${ntf.uid} at ${ntf.deadline}');
    return plug.zonedSchedule(
      ntf.id,
      ntf.title,
      ntf.description,
      tz.TZDateTime.local(
        ntf.deadline.year,
        ntf.deadline.month,
        ntf.deadline.day,
        ntf.deadline.hour,
        ntf.deadline.minute,
        ntf.deadline.second,
        ntf.deadline.millisecond,
        ntf.deadline.microsecond,
      ),
      platformChannelSpecifics,
      payload: 'notification-${ntf.uid}',
      androidAllowWhileIdle: true,
      matchDateTimeComponents:
          (ntf.repeat == 0) ? null : DateTimeComponents.values[ntf.repeat - 1],
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleFromNotifyNotificationList(
    final List<NotifyNotification> list,
  ) async =>
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach(
        (final NotifyNotification element) async {
          if (element.deadline.isAfter(DateTime.now())) {
            await scheduleFromNotifyNotification(element);
          }
        },
      );
}
