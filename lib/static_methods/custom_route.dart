import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Returns a custom [PageRoute] that is automatically changed for the system.
/// As an argument, it is necessary to pass the screen to which the redirection
/// will go
PageRoute<T> customRoute<T>(final Widget screen) {
  if (Platform.isIOS || Platform.isMacOS) {
    return CupertinoPageRoute<T>(
      builder: (final BuildContext context) => screen,
    );
  } else {
    return MaterialPageRoute<T>(
      builder: (final BuildContext context) => screen,
    );
  }
}
