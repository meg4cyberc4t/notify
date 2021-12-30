import 'package:flutter/material.dart';

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
    return ListTile(
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
      tileColor: Theme.of(context).cardColor,
      minLeadingWidth: 0,
    );
  }
}
