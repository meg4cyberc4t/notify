import 'package:firebase_auth/firebase_auth.dart';

abstract class IApiClient {
  // ignore: unused_field
  abstract final String _prefix;
  Future<String> getTokenAsync() =>
      FirebaseAuth.instance.currentUser!.getIdToken();
}
