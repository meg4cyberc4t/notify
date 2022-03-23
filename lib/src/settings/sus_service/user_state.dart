import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class UserState extends ChangeNotifier {
  UserState();
  late NotifyUserDetailed _user;
  NotifyUserDetailed get user => _user;

  void load() async {
    _user = await ApiService.user.get();
    notifyListeners();
  }

  void edit(
      {String? firstname,
      String? lastname,
      String? status,
      Color? color}) async {
    _user = await ApiService.user.put(
      firstname: firstname ?? user.firstname,
      lastname: lastname ?? user.lastname,
      status: status ?? user.status,
      color: color ?? user.color,
    );
    notifyListeners();
  }
}
