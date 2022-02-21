import 'package:firebase_auth/firebase_auth.dart';

class ApiClientConfig {
  static const String serverAddress = 'http://185.12.95.190';

  static const String userControllerPrefix = '/user';
  static const String usersControllerPrefix = '/users';
  static const String searchControllerPrefix = '/search';
  static const String notificationsControllerPrefix = '/notifications';
  static const String folderControllerPrefix = '/folders';

  static const String subscribtions = '/subscriptions';
  static const String subscribers = '/subscribers';
  static const String changeSubscription = '/change_subscription';

  static const String fromUsers = '/from_users';
  static const String fromNotifications = '/from_notifications';
  static const String fromFolders = '/from_folders';

  static Future<String> get token =>
      FirebaseAuth.instance.currentUser!.getIdToken();
}
