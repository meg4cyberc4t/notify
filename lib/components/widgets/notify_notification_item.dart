import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/notify_theme.dart';

class NotifyNotificationItem extends StatelessWidget {
  const NotifyNotificationItem({
    Key? key,
    required this.title,
    required this.datetime,
    required this.onTap,
    this.priority = false,
    this.subtitle,
  }) : super(key: key);

  final String title;
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
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          width: 4,
          color: priority
              ? NotifyTheme.of(context).mainAccentColor1
              : NotifyTheme.of(context).mainAccentColor2,
        ),
      ),
      trailing: Text(DateFormat('H:M').format(datetime)),
      title: Text(title),
      minLeadingWidth: 0,
    );
  }
}
