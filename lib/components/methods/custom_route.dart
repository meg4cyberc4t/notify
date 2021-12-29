import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

PageRoute<T> customRoute<T>(Widget screen) {
  return Platform.isIOS || Platform.isMacOS
      ? CupertinoPageRoute<T>(builder: (context) => screen)
      : MaterialPageRoute<T>(builder: (context) => screen);
}
