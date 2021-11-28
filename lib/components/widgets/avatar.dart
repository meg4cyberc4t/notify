import 'package:flutter/material.dart';

enum AvatarSize {
  max,
  middle,
  mini,
}

class Avatar extends StatelessWidget {
  const Avatar({
    required this.size,
    required this.color,
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final AvatarSize size;
  final Color color;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    Color textColor =
        brightness == Brightness.light ? Colors.black : Colors.white;
    late double height;
    late double width;
    late TextStyle textStyle;
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
          duration: const Duration(milliseconds: 500),
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
}
