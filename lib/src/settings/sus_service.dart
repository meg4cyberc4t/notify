import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

/// Screen Update Service
/// The use of these states is not supposed to be Cubit,
/// but as a replacement for setState with access in different routers
class _LocalState extends ChangeNotifier {
  void updateState() => notifyListeners();
}

class HomeLocalState extends _LocalState {}

class NotificationViewLocalState extends _LocalState {}

class NotificationParticipantsLocalState extends _LocalState {}

class CalendarPageState extends _LocalState {}
