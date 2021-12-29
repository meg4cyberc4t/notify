import 'package:flutter/material.dart';
import 'package:notify/notify_theme.dart';

enum NotifyDirectButtonStyle {
  primary,
  outlined,
  slience,
}

class NotifyDirectButton extends StatelessWidget {
  const NotifyDirectButton({
    Key? key,
    this.style = NotifyDirectButtonStyle.primary,
    required this.onPressed,
    this.title,
    this.icon,
    this.isExpanded = true,
  }) : super(key: key);

  final NotifyDirectButtonStyle style;
  final VoidCallback onPressed;
  final String? title;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    double iconSize = 24;
    double elevation = 4;
    Color foregroundColor;
    Color buttonColor;
    BorderSide borderSide = BorderSide.none;
    TextStyle textStyle = NotifyTheme.of(context).mainTextTheme().button!;
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        foregroundColor = NotifyTheme.of(context).backgroundColor;
        buttonColor = NotifyTheme.of(context).mainAccentColor1;
        break;
      case NotifyDirectButtonStyle.outlined:
        foregroundColor = NotifyTheme.of(context).mainAccentColor1;
        buttonColor = NotifyTheme.of(context).backgroundColor;
        borderSide =
            BorderSide(color: NotifyTheme.of(context).mainAccentColor1);
        break;
      case NotifyDirectButtonStyle.slience:
        foregroundColor = NotifyTheme.of(context).mainAccentColor1;
        buttonColor = NotifyTheme.of(context).backgroundColor;
        elevation = 0;
        break;
    }

    return MaterialButton(
      color: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: borderSide,
      ),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: iconSize,
                  color: foregroundColor,
                ),
              if (icon != null && title != null) const SizedBox(width: 10),
              if (title != null)
                Text(
                  "$title",
                  style: textStyle.copyWith(color: foregroundColor),
                ),
            ],
          )),
      onPressed: onPressed,
      elevation: elevation,
      animationDuration: NotifyTheme.of(context).duration,
    );
  }
}
