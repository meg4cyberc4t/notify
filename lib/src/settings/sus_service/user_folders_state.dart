import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class UserFoldersState extends ChangeNotifier {
  List<NotifyFolderQuick> _folders = [];
  UserFoldersState();

  void load() async {
    _folders = await ApiService.folders.get();
    notifyListeners();
  }

  UnmodifiableListView<NotifyFolderQuick> get folders =>
      UnmodifiableListView(_folders);
}
