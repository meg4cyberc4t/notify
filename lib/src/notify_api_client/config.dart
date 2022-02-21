import 'package:firebase_auth/firebase_auth.dart';

class ApiClientConfig {
  static const String serverAddress = 'http://185.12.95.190';

  static const String userControllerPrefix = '/user';

  static Future<String> get token =>
      FirebaseAuth.instance.currentUser!.getIdToken();
}
