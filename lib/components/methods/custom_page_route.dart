import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customRoute(Widget Function(BuildContext) builder) => Platform.isAndroid
    ? MaterialPageRoute(builder: builder)
    : CupertinoPageRoute(builder: builder);
