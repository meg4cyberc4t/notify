import 'package:flutter/material.dart';

class NotifyTextButton extends StatelessWidget {
  const NotifyTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
