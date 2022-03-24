import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/components/view_models/notification_list_tile.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);
  static const routeName = 'calendar_view';

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _rangeController = TextEditingController();

  final ValueNotifier<DateTime> start = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime> end = ValueNotifier(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendar),
      ),
      body: Consumer<UserNotificationsState>(
        builder: (context, state, __) => RefreshIndicator(
          onRefresh: () async =>
              Provider.of<UserNotificationsState>(context, listen: false)
                  .load(),
          child: ValueListenableBuilder(
            valueListenable: start,
            builder: (
              BuildContext context,
              DateTime startOfRange,
              Widget? _,
            ) =>
                ValueListenableBuilder(
                    valueListenable: end,
                    builder: (
                      BuildContext context,
                      DateTime endOfRange,
                      Widget? _,
                    ) {
                      Iterable<NotifyNotificationQuick?> ntfsItems =
                          state.notifications.where((e) =>
                              e.deadline.isAfter(startOfRange) &&
                              e.deadline.isBefore(endOfRange));
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _rangeController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Даты',
                                          hintText: 'Выберите диапазон дат',
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onTap: () async {
                                          final DateTimeRange? range =
                                              await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 3450)),
                                            currentDate: DateTime.now(),
                                          );
                                          if (range == null) return;
                                          _rangeController.text =
                                              DateFormat('dd.MM.yyyy')
                                                      .format(range.start) +
                                                  ' - ' +
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(range.end);
                                          start.value = range.start;
                                          end.value = range.end;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (ntfsItems.isEmpty)
                            SizedBox(
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.search_off_outlined),
                                    Text(
                                        AppLocalizations.of(context)!.notFound),
                                  ],
                                ),
                              ),
                            ),
                          ...ntfsItems.map(
                              (e) => NotificationListTile(notification: e)),
                        ],
                      );
                    }),
          ),
        ),
      ),
    );
  }
}
