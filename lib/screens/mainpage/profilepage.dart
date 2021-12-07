import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/components/widgets/direct_button.dart';
import 'package:notify/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  final String login = 'meg4cyberc4t';
  final String firstName = 'Igor';
  final String lastName = 'Molchanov';
  final Color avatarColor = Colors.lightGreen;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final String avatarTitle =
        (widget.firstName[0] + widget.lastName[0]).toUpperCase();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 1,
            primary: true,
            backgroundColor: Theme.of(context).backgroundColor,
            titleTextStyle: Theme.of(context).textTheme.headline4,
            title: Text(widget.login),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.settings),
                onPressed: () {},
              ),
            ],
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Avatar(
                  size: AvatarSize.max,
                  color: Colors.blueGrey,
                  title: avatarTitle,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.firstName,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      widget.lastName,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: NotifyDirectButton.icon(
                      onPressed: () {},
                      text: 'Add',
                      icon: CupertinoIcons.person_add_solid,
                      isOutlined: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: NotifyDirectButton.icon(
                    icon: CupertinoIcons.qrcode,
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    text: 'QR code',
                  ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: NotifyDirectButton.text(
                      text: 'logout',
                      onPressed: () async {
                        await context.read<AuthenticationService>().signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SliverStickyHeader(
          //   header: miniSliverHeader(
          //     context,
          //     'Today Tasks',
          //   ),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => NotificationItem(
          //         priority: i == 0,
          //         datetime: DateTime.now(),
          //         subtitle: i % 2 == 0 ? 'subtitle' : null,
          //         onTap: () {},
          //       ),
          //       childCount: 4,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
