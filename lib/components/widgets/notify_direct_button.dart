import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/configs/notify_parameters.dart';

/// Styles [NotifyDirectButtonStyle]
enum NotifyDirectButtonStyle {
  /// Full fill with the main color. There are no sides.
  primary,

  /// There is no fill, the sides are the background color.

  outlined,

  /// There is no fill, no sides.
  slience,

  /// Background fill, no sides,
  transparent,
}

/// The main button in the application
class NotifyDirectButton extends StatelessWidget {
  ///The main constructor of the button.
  /// [style] - one of the styles NotifyDirectButtonStyle
  /// [onPressed] - function when pressed
  /// [title] -Title
  /// [icon] - The icon to the left of the title.
  /// [isExpanded] - Whether the button will occupy the entire possible area.
  const NotifyDirectButton({
    required this.onPressed,
    final Key? key,
    final this.style = NotifyDirectButtonStyle.primary,
    final this.title,
    final this.icon,
    final this.isExpanded = true,
  }) : super(key: key);

  /// [style] - one of the styles NotifyDirectButtonStyle
  final NotifyDirectButtonStyle style;

  /// [onPressed] - function when pressed
  final VoidCallback onPressed;

  /// [title] -Title
  final String? title;

  /// [icon] - The icon to the left of the title.
  final IconData? icon;

  /// [isExpanded] - Whether the button will occupy the entire possible area.
  final bool isExpanded;

  @override
  Widget build(final BuildContext context) {
    const double iconSize = 24;
    Color buttonColor;
    BorderSide borderSide;
    double elevation;
    final TextStyle textStyle = Theme.of(context).textTheme.button!;
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
        borderSide = BorderSide(color: Theme.of(context).colorScheme.primary);
        elevation = 2;
        break;
      case NotifyDirectButtonStyle.slience:
        buttonColor = Theme.of(context).colorScheme.background;
        textColor = Theme.of(context).colorScheme.primary;
        borderSide = BorderSide.none;
        elevation = 0;
        break;
      case NotifyDirectButtonStyle.transparent:
        buttonColor = Colors.transparent;
        textColor = Theme.of(context).colorScheme.primary;
        borderSide = BorderSide.none;
        elevation = 0;
        break;
    }
    return RawMaterialButton(
      fillColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: borderSide,
      ),
      textStyle: textStyle.copyWith(color: textColor),
      onPressed: onPressed,
      elevation: elevation,
      animationDuration: NotifyParameters.duration,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) Icon(icon, size: iconSize, color: textColor),
            if (icon != null && title != null) const SizedBox(width: 10),
            if (title != null)
              Text(
                '$title',
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<bool>('isExpanded', isExpanded))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(EnumProperty<NotifyDirectButtonStyle>('style', style))
      ..add(StringProperty('title', title));
  }
}
