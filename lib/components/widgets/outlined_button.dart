import 'package:flutter/material.dart';

class NotifyOutlinedButton extends StatelessWidget {
  const NotifyOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.widget,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: widget,
      ),
      onPressed: onPressed,
    );
  }
}
