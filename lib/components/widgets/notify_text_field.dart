import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: public_member_api_docs
class NotifyTextField extends StatefulWidget {
  /// Branded [TextField]
  const NotifyTextField({
    final Key? key,
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
    this.autofocus = false,
    this.onFieldSubmitted,
  }) : super(key: key);

  /// Hiding text inside a field. Use with passwords
  final bool obscureText;

  /// Controller for interacting with a text field
  final TextEditingController? controller;

  /// The hint text that will be displayed when the input is empty
  final String? hintText;

  /// Text above the field
  final String? labelText;

  /// Initial value
  final String? initialValue;

  /// The function that will be launched after any input change
  final ValueChanged<String>? onChanged;

  /// The text warning about the error. Shown at the bottom and in red,
  /// null by default.
  final String? errorText;

  /// Auto-correction in the field.
  final bool? autocorrect;

  /// Maximum number of rows. Make 1 if you want one row.
  final int maxLines;

  /// Minimun number of rows.
  final int? minLines;

  /// Autofocus on the text field when available.
  final bool autofocus;

  ///The function that is called when the field is submitted
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<NotifyTextField> createState() => NotifyTextFieldState();
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('obscureText', obscureText))
      ..add(
        DiagnosticsProperty<TextEditingController?>('controller', controller),
      )
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('labelText', labelText))
      ..add(StringProperty('initialValue', initialValue))
      ..add(
        ObjectFlagProperty<ValueChanged<String>?>.has('onChanged', onChanged),
      )
      ..add(StringProperty('errorText', errorText))
      ..add(DiagnosticsProperty<bool?>('autocorrect', autocorrect))
      ..add(IntProperty('maxLines', maxLines))
      ..add(IntProperty('minLines', minLines))
      ..add(DiagnosticsProperty<bool>('autofocus', autofocus))
      ..add(
        ObjectFlagProperty<ValueChanged<String>?>.has(
          'onFieldSubmitted',
          onFieldSubmitted,
        ),
      );
  }
}

// ignore: public_member_api_docs
class NotifyTextFieldState extends State<NotifyTextField> {
  @override
  Widget build(final BuildContext context) => TextFormField(
        autofocus: widget.autofocus,
        key: widget.key,
        controller: widget.controller,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        autocorrect: widget.autocorrect ?? true,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        initialValue: widget.initialValue,
        style: Theme.of(context).textTheme.headline6,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
        ),
      );
}
