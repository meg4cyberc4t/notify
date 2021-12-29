import 'package:flutter/material.dart';
import 'package:notify/notify_theme.dart';

class NotifyTextField extends StatefulWidget {
  const NotifyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.initialValue,
    this.onChanged,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.autocorrect,
    this.onEditingComplete,
    this.autofocus = false,
  }) : super(key: key);
  final bool obscureText;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  final String? errorText;
  final bool? autocorrect;
  final int maxLines;
  final int? minLines;
  final bool autofocus;

  @override
  State<NotifyTextField> createState() => NotifyTextFieldState();
}

class NotifyTextFieldState extends State<NotifyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus,
      key: widget.key,
      controller: widget.controller,
      cursorColor: NotifyTheme.of(context).mainAccentColor1,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autocorrect: widget.autocorrect ?? true,
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      style: Theme.of(context).textTheme.headline5!.copyWith(
            color: Theme.of(context).textTheme.headline4!.color,
          ),
      obscureText: widget.obscureText,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).textTheme.headline4!.color,
            ),
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).textTheme.headline4!.color,
            ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: NotifyTheme.of(context).mainAccentColor1,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: NotifyTheme.of(context).mainAccentColor1,
            width: 2,
          ),
        ),
        errorText: widget.errorText,
        errorStyle: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: NotifyTheme.of(context).faultColor),
      ),
    );
  }
}
