import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/components/show_select_repeat_mode_bottom_sheet.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';

class CreateNotificationView extends StatefulWidget {
  const CreateNotificationView({Key? key}) : super(key: key);

  static const routeName = 'create_notification_view';

  @override
  State<CreateNotificationView> createState() => _CreateNotificationViewState();
}

class _CreateNotificationViewState extends State<CreateNotificationView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late ValueNotifier<DateTime> _deadlineNotifier;

  final TextEditingController _repeatModeController = TextEditingController();
  late ValueNotifier<RepeatMode> _repeatModeNotifier;

  final TextEditingController _imporantController = TextEditingController();
  late ValueNotifier<bool> _importantNotifier;

  @override
  void initState() {
    final DateTime deadline = DateTime.now().add(const Duration(minutes: 1));
    _deadlineNotifier = ValueNotifier(deadline);

    _repeatModeNotifier = ValueNotifier(RepeatMode.none);
    _importantNotifier = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _deadlineNotifier.dispose();
    _dateController.dispose();
    _timeController.dispose();

    _repeatModeNotifier.dispose();

    _importantNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text =
        DateFormat('yyyy.MM.dd').format(_deadlineNotifier.value);
    _timeController.text = DateFormat('HH:MM').format(_deadlineNotifier.value);
    _repeatModeController.text =
        getRepeatModeTitle(context, _repeatModeNotifier.value);
    _imporantController.text = _importantNotifier.value
        ? AppLocalizations.of(context)!.yes
        : AppLocalizations.of(context)!.no;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createNotification),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 8,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.title,
                    counterText: '',
                  ),
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterSomeText;
                    }
                    return null;
                  },
                  autofocus: true,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  minLines: 1,
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.date,
                        ),
                        controller: _dateController,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (_deadlineNotifier.value
                              .isBefore(DateTime.now())) {
                            return AppLocalizations.of(context)!.incorrectValue;
                          }
                          return null;
                        },
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _deadlineNotifier.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (date == null) return;
                          _deadlineNotifier.value = date;
                          _dateController.text =
                              DateFormat('dd.MM.yyyy').format(date);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.time,
                        ),
                        controller: _timeController,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (_deadlineNotifier.value
                              .isBefore(DateTime.now())) {
                            return AppLocalizations.of(context)!.incorrectValue;
                          }
                          return null;
                        },
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(_deadlineNotifier.value),
                          );
                          if (time == null) return;
                          _timeController.text = time.format(context);
                          _deadlineNotifier.value = DateTime(
                            _deadlineNotifier.value.year,
                            _deadlineNotifier.value.month,
                            _deadlineNotifier.value.day,
                            time.hour,
                            time.minute,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.repeatMode,
                    alignLabelWithHint: true,
                  ),
                  minLines: 1,
                  readOnly: true,
                  onTap: () async {
                    final RepeatMode? rp = await showRepeatItBottomSheet(
                        context: context, value: _repeatModeNotifier.value);
                    if (rp == null) return;
                    _repeatModeNotifier.value = rp;
                    _repeatModeController.text =
                        getRepeatModeTitle(context, rp);
                    Vibrate.canVibrate.then((value) {
                      if (!value) return;
                      Vibrate.feedback(FeedbackType.light);
                    });
                  },
                  controller: _repeatModeController,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.important,
                    alignLabelWithHint: true,
                  ),
                  minLines: 1,
                  readOnly: true,
                  onTap: () async {
                    _importantNotifier.value = !_importantNotifier.value;
                    _imporantController.text = _importantNotifier.value
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no;
                    Vibrate.canVibrate.then((value) {
                      if (!value) return;
                      Vibrate.feedback(FeedbackType.light);
                    });
                  },
                  controller: _imporantController,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;
          try {
            await ApiService.notifications.post(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              deadline: _deadlineNotifier.value,
              important: _importantNotifier.value,
              repeatMode: _repeatModeNotifier.value,
            );
            Navigator.of(context).pop(true);
          } on ApiServiceException catch (err) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err.message),
            ));
          }
        },
      ),
    );
  }
}
