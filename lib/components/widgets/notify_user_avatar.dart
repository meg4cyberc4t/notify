// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/configs/notify_parameters.dart';

enum AvatarSize {
  max,
  middle,
  mini,
}

class NotifyAvatar extends StatelessWidget {
  const NotifyAvatar({
    required this.size,
    required this.color,
    required this.title,
    this.onTap,
    final Key? key,
  }) : super(key: key);

  final AvatarSize size;
  final Color color;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final Color textColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;
    double height;
    double width;
    TextStyle textStyle;
    switch (size) {
      case AvatarSize.max:
        height = 100;
        width = 100;
        textStyle =
            Theme.of(context).textTheme.headline3!.copyWith(color: textColor);
        break;
      case AvatarSize.middle:
        height = 75;
        width = 75;
        textStyle =
            Theme.of(context).textTheme.headline4!.copyWith(color: textColor);
        break;
      case AvatarSize.mini:
        height = 50;
        width = 50;
        textStyle =
            Theme.of(context).textTheme.headline5!.copyWith(color: textColor);
        break;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Hero(
        tag: '$title-${color.value}',
        child: AnimatedContainer(
          height: height,
          width: width,
          duration: NotifyParameters.duration,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<AvatarSize>('size', size))
      ..add(StringProperty('title', title))
      ..add(ColorProperty('color', color))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
