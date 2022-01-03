import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin plug = FlutterLocalNotificationsPlugin();

class NotificationService {
  static const String notificationsIcon = "logo";
  static initializingSettings() async {
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
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
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
    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  factory NotificationService() => _instance;
  NotificationService._();
  static final NotificationService _instance = NotificationService._();

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
      int id, String? title, String? body, String? payload) {
    debugPrint('Handle old notification!: $id, $title, $body, $payload');
  }

  static Future<void> _selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  int id = 0;

  Future<void> show({String? title, String? body, String? payload}) async =>
      await plug.show(
        id++,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

  Future<void> schedule({
    String? title,
    String? body,
    required DateTime dateTime,
    String? payload,
  }) async =>
      await plug.zonedSchedule(
        id++,
        title,
        body,
        tz.TZDateTime.local(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        ),
        platformChannelSpecifics,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
}
