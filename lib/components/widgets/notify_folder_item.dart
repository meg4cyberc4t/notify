import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The [ListTile] unit that is used in the application to display folders
class NotifyFolderItem extends StatelessWidget {
  /// [title] - Title
  /// [subtitle] - Subtitle
  /// [countNotifications] - Count of reminders in the folder
  /// [onPressed] - function when pressed

  const NotifyFolderItem({
    required this.title,
    required this.subtitle,
    required this.countNotifications,
    required this.onPressed,
    final Key? key,
  }) : super(key: key);

  /// [title] - Title
  final String title;

  /// [subtitle] - Subtitle
  final String subtitle;

  /// [countNotifications] - Count of reminders in the folder
  final int countNotifications;

  /// [onPressed] - function when pressed
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        onTap: onPressed,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          '$countNotifications ntf',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        // tileColor: Theme.of(context).appBarTheme.backgroundColor,
        minLeadingWidth: 0,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(IntProperty('countNotifications', countNotifications))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
