import 'package:flutter/material.dart';

class NotifyOutlinedTextButton extends StatelessWidget {
  const NotifyOutlinedTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button
              ?.copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
