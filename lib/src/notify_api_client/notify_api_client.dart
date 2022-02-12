// ignore_for_file: prefer_single_quotes

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notify/src/notify_api_client/errors/exception_handler.dart';
import 'package:notify/src/notify_api_client/interface_api_client.dart';
import 'package:notify/src/notify_api_client/models/notify_user_detailed.dart';

class ApiClient {
  static const _serverAddress = 'http://185.12.95.190';
  static _ApiClientUser get user => _ApiClientUser();
}

class _ApiClientUser extends IApiClient {
  String get _prefix => '/user';

  Future<NotifyUserDetailed> post({
    required final String firstname,
    required final String lastname,
    Color? color,
  }) async {
    color ??= Colors.primaries[Random().nextInt(Colors.primaries.length)];
    http.Response res =
        await http.post(Uri.parse(ApiClient._serverAddress + _prefix),
            body: jsonEncode({
              'firstname': firstname,
              'lastname': lastname,
              'color': color.value,
            }),
            encoding: Encoding.getByName('utf-8'),
            headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain',
          'Authorization': 'Bearer ${await getTokenAsync()}',
        });
    await statusCodeExceptionHandler(res);
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyUserDetailed> get() async {
    http.Response res =
        await http.get(Uri.parse(ApiClient._serverAddress + '/user'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getTokenAsync()}',
    });
    await statusCodeExceptionHandler(res);
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }
}
