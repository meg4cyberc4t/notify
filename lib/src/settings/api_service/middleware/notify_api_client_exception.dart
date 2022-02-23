import 'dart:io';

import 'package:flutter/material.dart';

class NotifyApiClientException extends IOException {
  NotifyApiClientException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;

  @override
  String toString() => statusCode.toString() + ':' + message.toString();

  String localTitle(final BuildContext context) {
    switch (statusCode) {
      case 409:
        return 'Почта уже используется!';
      case 404:
        return 'Нет интернета';
      case 400:
        return 'Проверьте введённые данные!';
      default:
        return 'Unknown error';
    }
  }
}
