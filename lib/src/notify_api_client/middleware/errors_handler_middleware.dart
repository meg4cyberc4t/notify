import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/config.dart';
import 'package:notify/src/notify_api_client/errors/exception_model.dart';
import 'package:notify/src/notify_api_client/requests/user_requests.dart';
import 'package:notify/src/pages/auth/check_email_view.dart';

Future<http.Response> errorsHandlerMiddlware({
  required Future<http.Response> Function() callback,
  required BuildContext context,
}) async {
  http.Response res = await callback();
  switch (res.statusCode) {
    case 412:
      // The user is authorized and confirmed by Firebase,
      // but there is no entry in the database
      User _user = FirebaseAuth.instance.currentUser!;
      List<String> _dname = _user.displayName!.split(' ');
      String firstname = _dname.length <= 1 ? _user.displayName! : _dname[0];
      String lastname = _dname.length <= 1 ? 'Just' : _dname[1];
      await errorsHandlerMiddlware(
          callback: UserResponses.post(
            firstname: firstname,
            lastname: lastname,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            token: await ApiClientConfig.token,
          ),
          context: context);
      return errorsHandlerMiddlware(callback: callback, context: context);
    case 403:
      // The user's email is not verified
      await Navigator.of(context).pushNamed(CheckEmailView.routeName);
      return errorsHandlerMiddlware(callback: callback, context: context);
  }
  if (res.statusCode >= 400) {
    debugPrint(res.toString());
    throw NotifyApiClientException(
      statusCode: res.statusCode,
      message: res.body,
    );
  }
  return res;
}
