// ignore_for_file: prefer_single_quotes

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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
  NotificationService._();
  static final NotificationService _instance = NotificationService._();

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

  int _id = 0;

  /// The function that will launch notifications right now
  Future<void> show({
    final String? title,
    final String? body,
    final String? payload,
  }) async =>
      plug.show(
        _id++,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

  /// A function that will launch notifications right now at a certain time
  Future<void> schedule({
    required final DateTime dateTime,
    final String? title,
    final String? body,
    final String? payload,
  }) async =>
      plug.zonedSchedule(
        _id++,
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
