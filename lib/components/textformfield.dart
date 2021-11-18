import 'package:flutter/material.dart';

class NotifyTextField extends StatelessWidget {
  const NotifyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  final bool obscureText;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      maxLines: 1,
      style: Theme.of(context).textTheme.headline4,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
              color: const Color(0xFF7A7979),
            ),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
              color: const Color(0xFF7A7979),
            ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
