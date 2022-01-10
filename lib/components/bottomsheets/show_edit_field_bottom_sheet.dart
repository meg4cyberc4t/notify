import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_text_field.dart';

/// Opens the BottomSheet with one input field
Future<T?> showEditFieldBottomSheet<T>(
  final BuildContext context, {
  required final String initialValue,
  final String? hintText,
  final String? labelText,
}) =>
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (final BuildContext context) => AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Container(
          height: 100,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: NotifyTextField(
              hintText: hintText,
              labelText: labelText,
              autofocus: true,
              initialValue: initialValue,
              onFieldSubmitted: (final String? value) =>
                  Navigator.of(context).pop(value),
            ),
          ),
        ),
      ),
    );
