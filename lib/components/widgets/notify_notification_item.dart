import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The [ListTile] unit that is used in the application to display notifications
class NotifyNotificationItem extends StatelessWidget {
  /// The main constructor of the button.
  /// [title] - One of the styles NotifyDirectButtonStyle
  /// [datetime] -DateTime of execution
  /// [onPressed] - Function when pressed
  /// [priority] - Is the notification prioritized
  const NotifyNotificationItem({
    required this.title,
    required this.datetime,
    required this.onPressed,
    final Key? key,
    this.priority = false,
  }) : super(key: key);

  /// [title] - One of the styles NotifyDirectButtonStyle
  final String title;

  /// [priority] - Is the notification prioritized
  final bool priority;

  /// [datetime] -DateTime of execution
  final DateTime datetime;

  /// [onPressed] - Function when pressed
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ListTile(
        onTap: onPressed,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            width: 4,
            color: priority
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
        trailing: Text(DateFormat('H:M').format(datetime)),
        title: Text(title),
        minLeadingWidth: 0,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<bool>('priority', priority))
      ..add(DiagnosticsProperty<DateTime>('datetime', datetime))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
