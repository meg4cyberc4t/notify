import 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:notify/src/settings/sus_service/theme_state.dart';
export 'package:notify/src/settings/sus_service/user_state.dart';
export 'package:notify/src/settings/sus_service/user_notifications_state.dart';

/// Screen Update Service
/// The use of these states is not supposed to be Cubit,
/// but as a replacement for setState with access in different routers
class _LocalState extends ChangeNotifier {
  void updateState() => notifyListeners();
}

class NotificationViewLocalState extends _LocalState {}

class NotificationParticipantsLocalState extends _LocalState {}

class FolderViewLocalState extends _LocalState {}

class FolderParticipantsLocalState extends _LocalState {}
