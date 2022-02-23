import 'package:flutter/material.dart';

Color getPassiveColor(Color activeColor) =>
    ThemeData.estimateBrightnessForColor(activeColor) == Brightness.light
        ? Colors.black
        : Colors.white;
