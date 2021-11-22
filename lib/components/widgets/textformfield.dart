import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyTextField extends StatefulWidget {
  const NotifyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.initialValue,
    this.onChanged,
  })  : assert(
          autovalidateMode != AutovalidateMode.disabled || validator == null,
          "You forgot to enable the validation function",
        ),
        super(key: key);
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final AutovalidateMode autovalidateMode;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  @override
  State<NotifyTextField> createState() => NotifyTextFieldState();
}

class NotifyTextFieldState extends State<NotifyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      validator: widget.validator,
      controller: widget.controller,
      autovalidateMode: widget.autovalidateMode,
      cursorColor: Theme.of(context).primaryColor,
      maxLines: 1,
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      style: Theme.of(context).textTheme.headline4,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.headline4!.copyWith(
              color: const Color(0xFF7A7979),
            ),
        labelText: widget.labelText,
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
        errorStyle: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: CupertinoColors.systemRed),
      ),
    );
  }
}
