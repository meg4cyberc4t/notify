import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.datetime,
    required this.priority,
    this.subtitle,
    required this.onTap,
  }) : super(key: key);

  final bool priority;
  final DateTime datetime;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          width: 5,
          color: priority
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
        ),
      ),
      trailing: Text(DateFormat('H:M').format(datetime)),
      title: const Text('List tile #0'),
      minLeadingWidth: 0,
    );
  }
}
