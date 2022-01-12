// ignore_for_file: public_member_api_docs
import 'package:date_picker_timeline/date_picker_timeline.dart'
    show DatePicker, DatePickerController;
import 'package:flutter/material.dart';
import 'package:notify/components/builders/custom_stream_builder.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/firebase_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({final Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final DatePickerController _controller = DatePickerController();
  final ValueNotifier<DateTime> _datetime =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 5),
          SizedBox(
            height: 85,
            child: CustomStreamBuilder<Stream<List<DateTime>>>.notify(
              stream: FirebaseService.of(context).getActiveDates(),
              onData: (
                final BuildContext context,
                final Stream<List<DateTime>> stream,
              ) =>
                  CustomStreamBuilder<List<DateTime>>.notify(
                stream: stream,
                onData: (
                  final BuildContext context,
                  final List<DateTime> activeDates,
                ) =>
                    DatePicker(
                  DateTime.now(),
                  controller: _controller,
                  initialSelectedDate: activeDates[0],
                  monthTextStyle: Theme.of(context).textTheme.subtitle2!,
                  dayTextStyle: Theme.of(context).textTheme.subtitle2!,
                  dateTextStyle: Theme.of(context).textTheme.subtitle1!,
                  selectedTextColor: Theme.of(context).colorScheme.onPrimary,
                  selectionColor: Theme.of(context).colorScheme.primary,
                  onDateChange: (final DateTime date) => _datetime.value = date,
                  activeDates: activeDates,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<DateTime>(
              valueListenable: _datetime,
              builder: (
                final BuildContext context,
                final DateTime value,
                final _,
              ) =>
                  CustomStreamBuilder<Stream<List<NotifyNotification>>>.notify(
                stream: FirebaseService.of(context)
                    .getNotificationsAboutDateSnapshot(value),
                onData: (
                  final BuildContext context,
                  final Stream<List<NotifyNotification>> stream,
                ) =>
                    CustomStreamBuilder<List<NotifyNotification>>.notify(
                  stream: stream,
                  onData: (
                    final BuildContext context,
                    final List<NotifyNotification> data,
                  ) =>
                      Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: 5),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Tasks',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                      Expanded(
                        child: NotifyItemsList(
                          list: data,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
