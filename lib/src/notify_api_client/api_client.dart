import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notify/src/notify_api_client/config.dart';
import 'package:notify/src/notify_api_client/middleware/errors_handler_middleware.dart';
import 'package:notify/src/notify_api_client/models/notify_user_detailed.dart';
import 'package:notify/src/notify_api_client/models/notify_user_quick.dart';
import 'package:notify/src/notify_api_client/requests/user_requests.dart';

class ApiClient {
  static late BuildContext _context;
  static initWithContext(BuildContext context) {
    _context = context;
  }

  static _ApiClientUser get user => _ApiClientUser();
}

class _ApiClientUser {
  Future<NotifyUserDetailed> post({
    required String firstname,
    required String lastname,
    Color? color,
  }) async {
    color ??= Colors.primaries[Random().nextInt(Colors.primaries.length)];
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.post(
            firstname: firstname,
            lastname: lastname,
            color: color,
            token: await ApiClientConfig.token),
        context: ApiClient._context);
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyUserDetailed> get() async {
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.get(token: await ApiClientConfig.token),
        context: ApiClient._context);
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyUserDetailed> put({
    required String firstname,
    required String lastname,
    required Color color,
  }) async {
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.put(
            firstname: firstname,
            lastname: lastname,
            color: color,
            token: await ApiClientConfig.token),
        context: ApiClient._context);
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<List<NotifyUserQuick>> subscriptions() async {
    var res = await errorsHandlerMiddlware(
        callback:
            UserResponses.subscriptions(token: await ApiClientConfig.token),
        context: ApiClient._context);
    return jsonDecode(res.body).map((e) => NotifyUserQuick.fromJson(e));
  }

  Future<List<NotifyUserQuick>> subscribers() async {
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.subscribers(token: await ApiClientConfig.token),
        context: ApiClient._context);
    return jsonDecode(res.body).map((e) => NotifyUserQuick.fromJson(e));
  }
}
