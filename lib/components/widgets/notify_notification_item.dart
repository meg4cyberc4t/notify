import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifyNotificationItem extends StatelessWidget {
  const NotifyNotificationItem({
    Key? key,
    required this.title,
    required this.datetime,
    required this.onTap,
    this.priority = false,
  }) : super(key: key);

  final String title;
  final bool priority;
  final DateTime datetime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
  }
}
