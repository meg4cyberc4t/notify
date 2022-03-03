import 'package:firebase_auth/firebase_auth.dart';

class ApiServiceConfig {
  static const String serverAddress = 'http://185.12.95.190';

  static const String userControllerPrefix = '/user';
  static const String usersControllerPrefix = '/users';
  static const String searchControllerPrefix = '/search';
  static const String notificationsControllerPrefix = '/notifications';
  static const String foldersControllerPrefix = '/folders';

  static const String subscriptions = '/subscriptions';
  static const String subscribers = '/subscribers';
  static const String changeSubscription = '/change_subscription';

  static const String fromUsers = '/from_users';
  static const String fromNotifications = '/from_notifications';
  static const String fromFolders = '/from_folders';

  static const String notifications = '/notifications';
  static const String participants = '/participants';
  static const String invite = '/invite';
  static const String exclude = '/exclude';

  static const String addNotification = '/add_notification';
  static const String removeNotification = '/remove_notification';

  static Future<String> get token =>
      FirebaseAuth.instance.currentUser!.getIdToken();
}
