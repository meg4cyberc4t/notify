// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/bottomsheets/show_edit_date_bottom_sheet.dart';
import 'package:notify/components/bottomsheets/show_edit_field_bottom_sheet.dart';
import 'package:notify/components/bottomsheets/show_repeat_it_bottom_sheet.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/static_methods/snapshot_middleware.dart';

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
  Widget build(final BuildContext context) => StreamBuilder<NotifyNotification>(
        stream: FirebaseService.of(context)
            .getNotificationFromIdSnapshots(widget.id),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<NotifyNotification> snapshot,
        ) {
          final Widget? handler = snapshotMiddleware(snapshot);
          if (handler != null) {
            return SizedBox(height: 300, child: handler);
          }
          final NotifyNotification ntf = snapshot.data!;

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(ntf.title),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final String? newValue = await showEditFieldBottomSheet(
                        context,
                        initialValue: ntf.title,
                        labelText: 'Title',
                      );
                      if (newValue != null && mounted) {
                        await FirebaseService.of(context)
                            .editNotificationFromId(
                                widget.id, <String, dynamic>{
                          'title': newValue,
                        });
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
                    onTap: () async {
                      final String? newValue = await showEditFieldBottomSheet(
                        context,
                        initialValue: ntf.description,
                        labelText: 'Description',
                      );
                      if (newValue != null && mounted) {
                        await FirebaseService.of(context)
                            .editNotificationFromId(
                                widget.id, <String, dynamic>{
                          'description': newValue,
                        });
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
                    onTap: () async {
                      final DateTime? newValue = await showEditDateBottomSheet(
                        context,
                        initialValue: ntf.deadline,
                      );
                      if (newValue != null && mounted) {
                        await FirebaseService.of(context)
                            .editNotificationFromId(
                                widget.id, <String, dynamic>{
                          'deadline': newValue,
                        });
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
                              DateFormat('y MMM d HH:mm').format(ntf.deadline),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async =>
                        FirebaseService.of(context).editNotificationFromId(
                      widget.id,
                      <String, dynamic>{
                        'priority': !ntf.priority,
                      },
                    ),
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
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final int? newValue = await showRepeatItBottomSheet(
                        context,
                        ntf.repeat,
                      );
                      if (newValue != null && mounted) {
                        await FirebaseService.of(context)
                            .editNotificationFromId(
                          widget.id,
                          <String, dynamic>{
                            'repeat': newValue,
                          },
                        );
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
                              'Repeat it: ',
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
                  Column(
                    children: <Widget>[
                      Text(
                        'Owner:',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<NotifyUser>(
                        stream: FirebaseService.of(context)
                            .getInfoAboutUser(ntf.owner),
                        builder: (
                          final BuildContext context,
                          final AsyncSnapshot<NotifyUser> snapshot,
                        ) =>
                            Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: snapshotMiddleware(snapshot) ??
                              NotifyUserListTile(user: snapshot.data!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}
