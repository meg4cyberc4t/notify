import 'package:flutter/material.dart';

extension PassiveColor on Color {
  get passive => ThemeData.estimateBrightnessForColor(this) == Brightness.light
      ? Colors.black
      : Colors.white;
}
