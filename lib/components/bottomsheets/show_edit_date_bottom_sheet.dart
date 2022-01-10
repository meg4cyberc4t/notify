import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';

/// Opens the BottomSheet with one input field
Future<T?> showEditDateBottomSheet<T>(
  final BuildContext context, {
  required final DateTime initialValue,
}) {
  final ValueNotifier<DateTime> _dl = ValueNotifier<DateTime>(initialValue);
  return showModalBottomSheet(
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
        color: Colors.transparent,
        height: 265,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                  ),
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _dl,
                    builder: (
                      final BuildContext context,
                      final DateTime value,
                      final _,
                    ) =>
                        CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: initialValue,
                      onDateTimeChanged: (final DateTime value) {
                        Vibrate.canVibrate.then((final bool value) {
                          if (value) {
                            Vibrate.feedback(FeedbackType.light);
                          }
                        });
                        _dl.value = DateTime(
                          _dl.value.year,
                          _dl.value.month,
                          _dl.value.day,
                          value.hour,
                          value.minute,
                        );
                      },
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final DateTime? newValue = await showDatePicker(
                    context: context,
                    // locale: const Locale('ru', 'RU'),
                    firstDate: DateTime.now(),
                    initialDate: _dl.value,
                    lastDate: DateTime.now().add(
                      const Duration(days: 3650),
                    ),
                  );
                  if (newValue != null) {
                    _dl.value = DateTime(
                      newValue.year,
                      newValue.month,
                      newValue.day,
                      _dl.value.hour,
                      _dl.value.minute,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _dl,
                    builder: (
                      final BuildContext context,
                      final DateTime value,
                      final Widget? child,
                    ) =>
                        Text(
                      DateFormat.yMMMd().format(value),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
              NotifyDirectButton(
                title: 'Save',
                onPressed: () => Navigator.of(context).pop(_dl.value),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
