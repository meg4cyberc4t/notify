import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/settings/notifications_service.dart';
import 'package:notify/src/settings/settings_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initializingSettings();
  await SettingsService.instance.init();
  final settingsController = SettingsController();
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}
