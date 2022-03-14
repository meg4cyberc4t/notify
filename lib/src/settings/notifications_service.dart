import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// FlutterLocalNotificationsPlugin.instance
FlutterLocalNotificationsPlugin plug = FlutterLocalNotificationsPlugin();

/// The main service is a layer that is used for native and convenient
/// interaction with notifications in the application
class NotificationService {
  /// Factory constructor for interacting with only one instance of
  /// [NotificationService] throughout the application
  factory NotificationService() => instance;
  const NotificationService._();
  static const NotificationService instance = NotificationService._();

  /// File name for the logo in notifications
  static const String notificationsIcon = '@mipmap/launcher_icon';
  //@mipmap/launcher_icon

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
  static const NotificationDetails regularNotificationsChannelSpecifics =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'Regular Notifications',
      'Regular Notifications',
      playSound: false,
      enableVibration: false,
      ticker: 'ticker',
      setAsGroupSummary: true,
      groupKey: 'important',
    ),
    iOS: IOSNotificationDetails(threadIdentifier: 'Regular Notifications'),
  );

  /// Parameters of a important notification channel.
  static const NotificationDetails importantNotificationsChannelSpecifics =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'Imporant Notifications',
      'Imporant Notifications',
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      ticker: 'ticker',
    ),
    iOS: IOSNotificationDetails(threadIdentifier: 'Imporant Notifications'),
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

  /// Sets a deferred task in the phone's notification system.
  /// The notification will appear in the current time zone.
  Future<void> schedule(final NotifyNotificationQuick notification) {
    if (notification.deadline.isBefore(DateTime.now())) {
      debugPrint(
          'Can\'t schedule: ${notification.id} at ${notification.deadline}');
      return Future.value();
    }
    debugPrint('Schedule: ${notification.id} at ${notification.deadline}');

    return plug.zonedSchedule(
      notification.uniqueClaim,
      notification.title,
      notification.description.isNotEmpty ? notification.description : null,
      tz.TZDateTime.local(
        notification.deadline.year,
        notification.deadline.month,
        notification.deadline.day,
        notification.deadline.hour,
        notification.deadline.minute,
        notification.deadline.second,
        notification.deadline.millisecond,
        notification.deadline.microsecond,
      ),
      notification.important
          ? importantNotificationsChannelSpecifics
          : regularNotificationsChannelSpecifics,
      payload: notification.payload,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: (notification.repeatMode == RepeatMode.none)
          ? null
          : DateTimeComponents.values[notification.repeatMode.index - 1],
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int uniqueClaim) {
    debugPrint('Remove schedule $uniqueClaim');
    return plug.cancel(uniqueClaim);
  }

  /// Clears all reminder entries in the system.
  /// It is used to overwrite all reminders at the moment of loading.
  Future<void> cancelAll() {
    debugPrint('Remove all schedule');
    return plug.cancelAll();
  }
}
