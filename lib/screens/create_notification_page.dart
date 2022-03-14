// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/bottomsheets/show_repeat_it_bottom_sheet.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_parameters.dart';
import 'package:provider/provider.dart';

class CreateNotificationPage extends StatefulWidget {
  const CreateNotificationPage({
    final Key? key,
  }) : super(key: key);

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final ValueNotifier<DateTime> _deadline =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(false);
  final ValueNotifier<bool> imporant = ValueNotifier<bool>(false);
  final ValueNotifier<int> repeatIt = ValueNotifier<int>(0);

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deadline.dispose();
    _expanded.dispose();
    repeatIt.dispose();
    imporant.dispose();
    super.dispose();
  }

  static const double _horizontalPadding = 10;

  String? getRepeatItTitle(final int repeatIt) {
    switch (repeatIt) {
      case 1:
        return 'Everyday';
      case 2:
        return 'Everyweek';
      case 3:
        return 'Everymonth';
      case 4:
        return 'Everyyear';
    }
  }

  @override
  Widget build(final BuildContext context) {
    final Color hintColor = Theme.of(context).hintColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Create notification')),
      body: SingleChildScrollView(
        child: ValueListenableProvider<DateTime>.value(
          value: _deadline,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: NotifyTextField(
                  labelText: 'Title',
                  controller: _titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: NotifyTextField(
                  labelText: 'Description',
                  controller: _descriptionController,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Time',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: hintColor),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                  ),
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _deadline,
                    builder: (
                      final BuildContext context,
                      final DateTime value,
                      final _,
                    ) =>
                        CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (final DateTime value) {
                        Vibrate.canVibrate.then((final bool value) {
                          if (value) {
                            Vibrate.feedback(FeedbackType.selection);
                          }
                        });

                        _deadline.value = DateTime(
                          _deadline.value.year,
                          _deadline.value.month,
                          _deadline.value.day,
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
                    initialDate: _deadline.value,
                    lastDate: DateTime.now().add(
                      const Duration(days: 3650),
                    ),
                  );
                  if (newValue != null) {
                    _deadline.value = DateTime(
                      newValue.year,
                      newValue.month,
                      newValue.day,
                      _deadline.value.hour,
                      _deadline.value.minute,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _deadline,
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
              ExpansionPanelList(
                expansionCallback: (final int item, final bool status) {
                  setState(() => _expanded.value = !_expanded.value);
                },
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                children: <ExpansionPanel>[
                  ExpansionPanel(
                    backgroundColor: Theme.of(context).backgroundColor,
                    canTapOnHeader: true,
                    headerBuilder:
                        (final BuildContext context, final bool isExpanded) =>
                            Padding(
                      padding: const EdgeInsets.only(left: _horizontalPadding),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Additionally',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: hintColor),
                        ),
                      ),
                    ),
                    body: Column(
                      children: <Widget>[
                        ValueListenableProvider<bool>.value(
                          value: imporant,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: imporant,
                            builder: (
                              final BuildContext context,
                              final bool value,
                              final Widget? child,
                            ) =>
                                SwitchListTile(
                              inactiveThumbColor: Theme.of(context).hintColor,
                              value: value,
                              onChanged: (final _) {
                                Vibrate.canVibrate.then((final bool value) {
                                  if (value) {
                                    Vibrate.feedback(FeedbackType.selection);
                                  }
                                });
                                imporant.value = !imporant.value;
                              },
                              title: Text(
                                'Important',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableProvider<int>.value(
                          value: repeatIt,
                          child: ValueListenableBuilder<int>(
                            valueListenable: repeatIt,
                            builder: (
                              final BuildContext context,
                              final int value,
                              final Widget? child,
                            ) =>
                                SwitchListTile(
                              inactiveThumbColor: Theme.of(context).hintColor,
                              value: value != 0,
                              onChanged: (final _) async {
                                unawaited(
                                  Vibrate.canVibrate.then((final bool value) {
                                    if (value) {
                                      Vibrate.feedback(FeedbackType.selection);
                                    }
                                  }),
                                );
                                final int? newValue =
                                    await showRepeatItBottomSheet(
                                  context,
                                  value,
                                );
                                if (newValue != null) {
                                  repeatIt.value = newValue;
                                }
                              },
                              title: Text(
                                'Repeat it',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              subtitle: value != 0
                                  ? Text(getRepeatItTitle(value)!)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isExpanded: _expanded.value,
                  ),
                ],
                animationDuration: NotifyParameters.duration,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Column(
                  children: <Widget>[
                    NotifyDirectButton(
                      title: 'Create',
                      onPressed: () {
                        final String title = _titleController.text.trim();
                        final String desc = _descriptionController.text.trim();
                        if (repeatIt.value > 4 && repeatIt.value < 0) {
                          return;
                        }
                        if (title.isEmpty) {
                          return;
                        }
                        FirebaseService.createNotification(
                          title: title,
                          description: desc,
                          deadline: _deadline.value,
                          priority: imporant.value,
                          repeat: repeatIt.value,
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 10),
                    NotifyDirectButton(
                      title: 'Back',
                      onPressed: Navigator.of(context).pop,
                      style: NotifyDirectButtonStyle.outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ValueNotifier<bool>>('imporant', imporant))
      ..add(DiagnosticsProperty<ValueNotifier<int>>('repeatIt', repeatIt));
  }
}
