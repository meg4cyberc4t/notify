import 'package:flutter/material.dart';
import 'package:notify/configs/notify_parameters.dart';

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
    Color buttonColor;
    BorderSide borderSide;
    double elevation;
    TextStyle textStyle = Theme.of(context).textTheme.button!;
    Color textColor;
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        buttonColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.background;
        borderSide = BorderSide.none;
        elevation = 2;
        break;
      case NotifyDirectButtonStyle.outlined:
        buttonColor = Theme.of(context).colorScheme.background;
        textColor = Theme.of(context).colorScheme.primary;
        borderSide =
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 1);
        elevation = 2;
        break;
      case NotifyDirectButtonStyle.slience:
        buttonColor = Theme.of(context).colorScheme.background;
        textColor = Theme.of(context).colorScheme.primary;
        borderSide = BorderSide.none;
        elevation = 0;
        break;
    }
    return RawMaterialButton(
      fillColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: borderSide,
      ),
      textStyle: textStyle.copyWith(color: textColor),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, size: iconSize, color: textStyle.color),
              if (icon != null && title != null) const SizedBox(width: 10),
              if (title != null) Text("$title"),
            ],
          )),
      onPressed: onPressed,
      elevation: elevation,
      animationDuration: NotifyParameters.duration,
    );
  }
}
