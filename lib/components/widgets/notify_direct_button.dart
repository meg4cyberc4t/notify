import 'package:flutter/material.dart';
import 'package:notify/notify_theme.dart';

enum NotifyDirectButtonStyle {
  primary,
  outlined,
  slience,
}

class NotifyDirectButtonThemeData {
  const NotifyDirectButtonThemeData.fromStyle(this.style);

  final NotifyDirectButtonStyle style;

  TextStyle get textStyle {
    TextStyle mainTextStyle = buildTextTheme().button!;
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        return mainTextStyle.copyWith(
          color: NotifyColors.backgroundColor,
        );
      case NotifyDirectButtonStyle.outlined:
        return mainTextStyle.copyWith(
          color: NotifyColors.mainAccent1,
        );
      case NotifyDirectButtonStyle.slience:
        return mainTextStyle.copyWith(
          color: NotifyColors.mainAccent1,
        );
    }
  }

  double get iconSize => 24.0;

  Color get foregroundColor {
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        return NotifyColors.backgroundColor;
      case NotifyDirectButtonStyle.outlined:
        return NotifyColors.mainAccent1;
      case NotifyDirectButtonStyle.slience:
        return NotifyColors.mainAccent1;
    }
  }

  Color get buttonColor {
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        return NotifyColors.mainAccent1;
      case NotifyDirectButtonStyle.outlined:
        return NotifyColors.backgroundColor;
      case NotifyDirectButtonStyle.slience:
        return NotifyColors.backgroundColor;
    }
  }

  BorderSide get borderSide {
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        return BorderSide.none;
      case NotifyDirectButtonStyle.outlined:
        return const BorderSide(color: NotifyColors.mainAccent1);
      case NotifyDirectButtonStyle.slience:
        return BorderSide.none;
    }
  }

  double get elevation {
    switch (style) {
      case NotifyDirectButtonStyle.primary:
        return 4.0;
      case NotifyDirectButtonStyle.outlined:
        return 4.0;
      case NotifyDirectButtonStyle.slience:
        return 0.0;
    }
  }

  Duration get duration => const Duration(milliseconds: 400);
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
    NotifyDirectButtonThemeData theme =
        NotifyDirectButtonThemeData.fromStyle(style);

    return MaterialButton(
      color: theme.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: theme.borderSide,
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
                  size: theme.iconSize,
                  color: theme.foregroundColor,
                ),
              if (icon != null && title != null) const SizedBox(width: 10),
              if (title != null)
                Text(
                  "$title",
                  style: theme.textStyle,
                ),
            ],
          )),
      onPressed: onPressed,
      elevation: theme.elevation,
      animationDuration: theme.duration,
    );
  }
}
