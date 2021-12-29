import 'package:flutter/material.dart';
import 'package:notify/notify_theme.dart';

class NotifyFolderItem extends StatelessWidget {
  const NotifyFolderItem({
    Key? key,
    required this.header,
    required this.subtitle,
    required this.countNotifications,
    required this.onTap,
  }) : super(key: key);

  final String header;
  final String subtitle;
  final int countNotifications;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        onTap: onTap,
        title: Text(
          header,
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: Text(
          "$countNotifications ntf",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        tileColor: NotifyTheme.of(context).backgroundCardColor,
        minLeadingWidth: 0,
      ),
    );
  }
}
