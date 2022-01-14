// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/bottomsheets/show_edit_date_bottom_sheet.dart';
import 'package:notify/components/bottomsheets/show_edit_field_bottom_sheet.dart';
import 'package:notify/components/bottomsheets/show_repeat_it_bottom_sheet.dart';
import 'package:notify/components/builders/custom_future_builder.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    required final this.id,
    final Key? key,
  }) : super(key: key);
  final String id;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('id', id));
  }
}

class _NotificationPageState extends State<NotificationPage> {
  String getRepeatItTitle(final int repeatIt) {
    switch (repeatIt) {
      case 1:
        return 'Everyday';
      case 2:
        return 'Everyweek';
      case 3:
        return 'Everymonth';
      case 4:
        return 'Everyyear';
      default:
        return 'One-time';
    }
  }

  static const double _localHeight = 60;

  @override
  Widget build(final BuildContext context) =>
      CustomFutureBuilder<NotifyNotification>.notify(
        future: FirebaseService.of(context).getNotificationFromId(widget.id),
        onData: (
          final BuildContext context,
          final NotifyNotification ntf,
        ) =>
            Builder(
          builder: (final BuildContext context) {
            final bool disabled = ntf.deadline.isBefore(DateTime.now());
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(ntf.title),
              ),
              body: RefreshIndicator(
                onRefresh: () async => Future<void>.delayed(
                  const Duration(seconds: 1),
                  () async => setState(() {}),
                ),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    InkWell(
                      onTap: disabled
                          ? null
                          : () async {
                              final String? newValue =
                                  await showEditFieldBottomSheet(
                                context,
                                initialValue: ntf.title,
                                labelText: 'Title',
                              );
                              if (newValue != null &&
                                  mounted &&
                                  newValue != ntf.title &&
                                  newValue.isNotEmpty) {
                                await FirebaseService.of(context)
                                    .editNotificationFromId(
                                        widget.id, <String, dynamic>{
                                  'title': newValue,
                                });
                                setState(() {});
                              }
                            },
                      child: SizedBox(
                        height: _localHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Title: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                ntf.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: disabled
                          ? null
                          : () async {
                              final String? newValue =
                                  await showEditFieldBottomSheet(
                                context,
                                initialValue: ntf.description,
                                labelText: 'Description',
                              );
                              if (newValue != null &&
                                  mounted &&
                                  newValue != ntf.description) {
                                await FirebaseService.of(context)
                                    .editNotificationFromId(
                                        widget.id, <String, dynamic>{
                                  'description': newValue,
                                });
                                setState(() {});
                              }
                            },
                      child: SizedBox(
                        height: _localHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Description: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                ntf.description,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: disabled
                          ? null
                          : () async {
                              final DateTime? newValue =
                                  await showEditDateBottomSheet(
                                context,
                                initialValue: ntf.deadline,
                              );
                              if (newValue != null &&
                                  mounted &&
                                  newValue != ntf.deadline) {
                                await FirebaseService.of(context)
                                    .editNotificationFromId(
                                        widget.id, <String, dynamic>{
                                  'deadline': newValue,
                                });
                                setState(() {});
                              }
                            },
                      child: SizedBox(
                        height: _localHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Deadline: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                DateFormat('y MMM d HH:mm')
                                    .format(ntf.deadline),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: disabled
                          ? null
                          : () async {
                              await FirebaseService.of(context)
                                  .editNotificationFromId(
                                widget.id,
                                <String, dynamic>{
                                  'priority': !ntf.priority,
                                },
                              );
                              setState(() {});
                            },
                      child: SizedBox(
                        height: _localHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Important: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Switch(
                                value: ntf.priority,
                                inactiveThumbColor: Theme.of(context).hintColor,
                                onChanged: (final _) {
                                  FirebaseService.of(context)
                                      .editNotificationFromId(
                                    widget.id,
                                    <String, dynamic>{
                                      'priority': !ntf.priority,
                                    },
                                  );
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: disabled
                          ? null
                          : () async {
                              final int? newValue =
                                  await showRepeatItBottomSheet(
                                context,
                                ntf.repeat,
                              );
                              if (newValue != null &&
                                  mounted &&
                                  newValue != ntf.repeat &&
                                  newValue >= 0 &&
                                  newValue <= 4) {
                                await FirebaseService.of(context)
                                    .editNotificationFromId(
                                  widget.id,
                                  <String, dynamic>{
                                    'repeat': newValue,
                                  },
                                );
                                setState(() {});
                              }
                            },
                      child: SizedBox(
                        height: _localHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Repeat: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                getRepeatItTitle(ntf.repeat),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Creator:',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    CustomFutureBuilder<NotifyUser>.notify(
                      future: FirebaseService.of(context)
                          .getInfoAboutUser(ntf.owner),
                      onData: (
                        final BuildContext context,
                        final NotifyUser user,
                      ) =>
                          NotifyUserListTile(user: user),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
