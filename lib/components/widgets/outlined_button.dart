import 'package:flutter/material.dart';

class NotifyOutlinedButton extends StatelessWidget {
  const NotifyOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.widget,
    this.padding = const EdgeInsets.all(4.0),
  })  : text = null,
        super(key: key);
  const NotifyOutlinedButton.text({
    Key? key,
    required this.onPressed,
    required this.text,
    this.padding = const EdgeInsets.all(10.0),
  })  : widget = null,
        super(key: key);

  final String? text;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    Widget? selectWidget = text != null
        ? Text(text!,
            style: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: Theme.of(context).primaryColor))
        : widget;

    return MaterialButton(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: padding,
        child: selectWidget,
      ),
      onPressed: onPressed,
    );
  }
}
