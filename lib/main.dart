import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/src/settings/notifications_service.dart';
import 'package:notify/src/settings/settings_service.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;
  await Firebase.initializeApp();
  await NotificationService.initializingSettings();
  await SettingsService.instance.init();
  runApp(const MyApp());
}
