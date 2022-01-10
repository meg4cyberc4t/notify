import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_text_field.dart';

/// Opens the BottomSheet with one input field
Future<T?> showEditFieldBottomSheet<T>(
  final BuildContext context, {
  required final String initialValue,
  final String? hintText,
  final String? labelText,
}) async {
  final TextEditingController _controller =
      TextEditingController(text: initialValue);
  // final double ratio = 100 / MediaQuery.of(context).size.height;
  await showModalBottomSheet(
    context: context,
    builder: (final BuildContext context) => Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: NotifyTextField(
            controller: _controller,
            hintText: hintText,
            labelText: labelText,
            autofocus: true,
          ),
        ),
      ],
    ),
  );
}
