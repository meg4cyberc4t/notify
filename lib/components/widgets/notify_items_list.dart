// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/configs/notify_theme.dart';
import 'package:notify/screens/notification_page.dart';
import 'package:notify/screens/profile_page.dart';
import 'package:notify/services/classes/notify_folder.dart';
import 'package:notify/services/classes/notify_item.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/static_methods/custom_route.dart';

Widget _itemBuilder(
  final BuildContext context,
  final int index,
  final NotifyItem item,
) {
  switch (item.runtimeType) {
    case NotifyUser:
      final NotifyUser user = item as NotifyUser;
      return Row(
        children: <Widget>[
          NotifyUserListTile(
            user: user,
          ),
        ],
      );
    case NotifyNotification:
      final NotifyNotification ntf = item as NotifyNotification;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: _NotifyNotificationItem(
          key: Key('notification-${ntf.uid}'),
          title: ntf.title,
          subtitle: ntf.description,
          datetime: ntf.deadline,
          priority: ntf.priority,
          repeatIt: ntf.repeat,
          disabled: ntf.deadline.isBefore(DateTime.now()),
          onPressed: () => Navigator.of(context).push(
            customRoute(
              NotificationPage(id: ntf.uid),
            ),
          ),
        ),
      );
    case NotifyFolder:
      final NotifyFolder folder = item as NotifyFolder;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: _NotifyFolderItem(
          title: folder.title,
          subtitle: folder.description,
          countNotifications: folder.notifications.length,
          onPressed: () {},
        ),
      );

    default:
      return const SizedBox();
  }
}

class NotifyItemsList extends StatelessWidget {
  const NotifyItemsList({
    required final this.list,
    final Key? key,
    final this.controller,
    this.divider = true,
    this.dividerIndent = 80,
  }) : super(key: key);
  final List<NotifyItem> list;
  final ScrollController? controller;
  final bool divider;
  final double dividerIndent;
  @override
  Widget build(final BuildContext context) {
    if (list.isEmpty) {
      return ListView(
        controller: controller,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Text(
                'Not found',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      controller: controller,
      itemCount: list.length,
      separatorBuilder: (
        final BuildContext context,
        final int index,
      ) =>
          divider
              ? Divider(
                  height: 1,
                  indent: dividerIndent,
                )
              : const SizedBox(),
      itemBuilder: (
        final BuildContext context,
        final int index,
      ) =>
          _itemBuilder(context, index, list[index]),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<NotifyItem>('list', list))
      ..add(DiagnosticsProperty<ScrollController?>('controller', controller))
      ..add(DiagnosticsProperty<bool>('divider', divider))
      ..add(DoubleProperty('dividerIndent', dividerIndent));
  }
}

class SliverNotifyItemsList extends StatelessWidget {
  const SliverNotifyItemsList({
    required final this.list,
    this.divider = true,
    this.dividerIndent = 80,
    final Key? key,
  }) : super(key: key);
  final List<NotifyItem> list;
  final bool divider;
  final double dividerIndent;
  @override
  Widget build(final BuildContext context) {
    if (list.isEmpty) {
      SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: Text(
              'Not found',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (final BuildContext context, final int index) => Column(
          children: <Widget>[
            _itemBuilder(context, index, list[index]),
            if (list.length - 1 != index && divider)
              Divider(
                height: 1,
                indent: dividerIndent,
              ),
          ],
        ),
        childCount: list.length,
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<NotifyItem>('list', list))
      ..add(DiagnosticsProperty<bool>('divider', divider))
      ..add(DoubleProperty('dividerIndent', dividerIndent));
  }
}

class NotifyUserListTile extends StatelessWidget {
  const NotifyUserListTile({
    required final this.user,
    final this.isExpanded = true,
    final Key? key,
  }) : super(key: key);
  final NotifyUser user;
  final bool isExpanded;

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: () => Navigator.push(
          context,
          customRoute(
            ProfilePage(uid: user.uid),
          ),
        ),
        child: Padding(
          padding: isExpanded ? const EdgeInsets.all(10) : EdgeInsets.zero,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NotifyAvatar(
                  color: user.color,
                  title: user.avatarTitle,
                  size: AvatarSize.mini,
                ),
                const SizedBox(width: 15),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      if (user.status.isNotEmpty) const SizedBox(width: 10),
                      if (user.status.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 85,
                          child: Text(
                            user.status,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Theme.of(context).hintColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<NotifyUser>('user', user))
      ..add(DiagnosticsProperty<bool>('isExpanded', isExpanded));
  }
}

/// The [ListTile] unit that is used in the application to display notifications
class _NotifyNotificationItem extends StatelessWidget {
  /// The main constructor of the button.
  /// [title] - One of the styles NotifyDirectButtonStyle
  /// [datetime] -DateTime of execution
  /// [onPressed] - Function when pressed
  /// [priority] - Is the notification prioritized
  const _NotifyNotificationItem({
    required this.title,
    required this.subtitle,
    required this.priority,
    required this.repeatIt,
    required this.datetime,
    required this.onPressed,
    this.disabled = false,
    final Key? key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool priority;
  final int repeatIt;
  final DateTime datetime;
  final VoidCallback onPressed;
  final bool disabled;

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: disabled ? null : onPressed,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 4,
                color: disabled
                    ? Theme.of(context).hintColor
                    : priority
                        ? NotifyThemeData.primaryVariant
                        : NotifyThemeData.primary,
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: disabled ? Theme.of(context).hintColor : null,
                        ),
                  ),
                  if (subtitle.isNotEmpty) const SizedBox(width: 10),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Theme.of(context).hintColor),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                DateFormat(DateFormat.HOUR24_MINUTE).format(datetime),
                style: !disabled
                    ? null
                    : TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: disabled ? Theme.of(context).hintColor : null,
                      ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<bool>('priority', priority))
      ..add(DiagnosticsProperty<DateTime>('datetime', datetime))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed))
      ..add(StringProperty('subtitle', subtitle))
      ..add(IntProperty('repeatIt', repeatIt))
      ..add(DiagnosticsProperty<bool>('disabled', disabled));
  }
}

/// The [ListTile] unit that is used in the application to display folders
class _NotifyFolderItem extends StatelessWidget {
  /// [title] - Title
  /// [subtitle] - Subtitle
  /// [countNotifications] - Count of reminders in the folder
  /// [onPressed] - function when pressed

  const _NotifyFolderItem({
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
