import 'package:flutter/material.dart';

class NotifyDirectButton extends StatelessWidget {
  const NotifyDirectButton({
    Key? key,
    required this.onPressed,
    required this.widget,
    this.isOutlined = false,
    this.padding = const EdgeInsets.all(4.0),
  })  : text = null,
        icon = null,
        super(key: key);

  const NotifyDirectButton.text({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isOutlined = false,
    this.padding = const EdgeInsets.all(10.0),
  })  : widget = null,
        icon = null,
        super(key: key);

  const NotifyDirectButton.icon({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.isOutlined = false,
    this.padding = const EdgeInsets.all(10.0),
  })  : widget = null,
        super(key: key);

  final bool? isOutlined;
  final String? text;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Widget? widget;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    Widget? selectWidget;
    if (icon != null) {
      selectWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isOutlined!
                ? Theme.of(context).primaryColor
                : Theme.of(context).backgroundColor,
          ),
          const SizedBox(width: 10),
          Text(text!,
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: isOutlined!
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).backgroundColor,
                  )),
        ],
      );
    } else if (text != null) {
      selectWidget = Text(
        text!,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: isOutlined!
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
            ),
      );
    } else {
      selectWidget = widget;
    }

    return MaterialButton(
      color: isOutlined!
          ? Theme.of(context).backgroundColor
          : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: isOutlined!
            ? BorderSide(color: Theme.of(context).primaryColor)
            : BorderSide.none,
      ),
      child: Padding(
        padding: padding,
        child: selectWidget,
      ),
      onPressed: onPressed,
    );
  }
}
