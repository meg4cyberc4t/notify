// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notify/components/bottomsheets/show_logout_alert_dialog.dart';
import 'package:notify/components/bottomsheets/show_notify_items_bottom_sheet.dart';
import 'package:notify/components/builders/custom_future_builder.dart';
import 'package:notify/components/builders/custom_stream_builder.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/screens/color_picker_page.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_parameters.dart';
import 'package:notify/static_methods/custom_route.dart';
import 'package:provider/provider.dart';

/// The profile page allows you to view information about each user:
/// His first name, last name, status, as well as the number of subscriptions,
/// subscribers and colleagues,
class ProfilePage extends StatefulWidget {
  /// The main screen constructor
  const ProfilePage({this.uid, final Key? key}) : super(key: key);

  /// The uid of the user whose profile we are looking at.
  /// If null, then the uid of the authorized user will be
  /// substituted in the build of the screen
  final String? uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('uid', uid));
  }
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context);

    if (widget.uid == null || widget.uid == context.watch<User>().uid) {
      return const MyProfilePage();
    }
    final String profileUID = widget.uid!;

    return Scaffold(
      body: CustomStreamBuilder<bool>.notify(
        stream: FirebaseService.of(context)
            .checkFollowedAsStream(context.watch<User>().uid, profileUID),
        onData: (
          final BuildContext context,
          final bool isFollowed,
        ) =>
            CustomStreamBuilder<NotifyUser>.notify(
          stream:
              FirebaseService.of(context).getInfoAboutUserAsStream(profileUID),
          onData: (
            final BuildContext context,
            final NotifyUser user,
          ) {
            final Color passiveColor =
                ThemeData.estimateBrightnessForColor(user.color) ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white;

            return RefreshIndicator(
              onRefresh: () => Future<void>.delayed(
                const Duration(seconds: 1),
                () async => setState(() {}),
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: passiveColor),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          isFollowed
                              ? CupertinoIcons.minus
                              : CupertinoIcons.add,
                        ),
                        onPressed: () async {
                          await FirebaseService.of(context)
                              .followSwitch(profileUID);
                          setState(() {});
                        },
                      ),
                    ],
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: passiveColor),
                      ),
                      background: AnimatedContainer(
                        duration: NotifyParameters.duration,
                        color: user.color,
                      ),
                    ),
                    pinned: true,
                    backgroundColor: user.color,
                  ),
                  if (user.status.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          user.status,
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    sliver: SliverToBoxAdapter(
                      child: NotifyDirectButton(
                        title: isFollowed ? 'Remove' : 'Add',
                        style: isFollowed
                            ? NotifyDirectButtonStyle.outlined
                            : NotifyDirectButtonStyle.primary,
                        onPressed: () async => FirebaseService.of(context)
                            .followSwitch(profileUID),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _preWidgetCountUsers(
                            context,
                            future: FirebaseService.of(context)
                                .getColleguesFromUser(profileUID),
                            title: 'Collegues',
                          ),
                          _localDivider,
                          _preWidgetCountUsers(
                            context,
                            future: FirebaseService.of(context)
                                .getFollowersFromUser(profileUID),
                            title: 'Followers',
                          ),
                          _localDivider,
                          _preWidgetCountUsers(
                            context,
                            future: FirebaseService.of(context)
                                .getFollowingFromUser(profileUID),
                            title: 'Following',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final Container _localDivider = Container(
  height: 50,
  width: 1,
  color: Colors.grey,
);

Expanded _preWidgetCountUsers(
  final BuildContext context, {
  required final Future<List<NotifyUser>> future,
  required final String title,
}) =>
    Expanded(
      child: CustomFutureBuilder<List<NotifyUser>>.notify(
        future: future,
        onData: (
          final BuildContext context,
          final List<NotifyUser> data,
        ) =>
            InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => showNotifyItemsBottomSheet(
            context,
            data,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                data.length.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({final Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final String uid;

  @override
  void initState() {
    uid = context.read<User>().uid;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomStreamBuilder<NotifyUser>.notify(
        stream: FirebaseService.of(context).getInfoAboutUserAsStream(uid),
        onData: (
          final BuildContext context,
          final NotifyUser user,
        ) {
          final Color passiveColor =
              ThemeData.estimateBrightnessForColor(user.color) ==
                      Brightness.light
                  ? Colors.black
                  : Colors.white;

          return RefreshIndicator(
            onRefresh: () async => Future<void>.delayed(
              const Duration(seconds: 1),
              () async => setState(() {}),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: passiveColor),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async => showLogoutAlertDialog(context),
                    ),
                  ],
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.pen),
                    onPressed: () async {
                      final Color? inputColor = await Navigator.push(
                        context,
                        customRoute(
                          ColorPickerPage(
                            title: user.avatarTitle,
                            initialValue: user.color,
                          ),
                        ),
                      );
                      if (inputColor != null &&
                          mounted &&
                          inputColor != user.color) {
                        await FirebaseService.of(context)
                            .updateInfoAboutUser(<String, dynamic>{
                          'color_r': inputColor.red,
                          'color_g': inputColor.green,
                          'color_b': inputColor.blue,
                        });
                        setState(() {});
                      }
                    },
                  ),
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: passiveColor),
                    ),
                    background: AnimatedContainer(
                      duration: NotifyParameters.duration,
                      color: user.color,
                    ),
                  ),
                  pinned: true,
                  backgroundColor: user.color,
                ),
                if (user.status.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        user.status,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverToBoxAdapter(
                    child: NotifyDirectButton(
                      title: 'Edit',
                      style: NotifyDirectButtonStyle.outlined,
                      onPressed: () async => Navigator.pushNamed(
                        context,
                        '/ProfilePageEdit',
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _preWidgetCountUsers(
                          context,
                          future: FirebaseService.of(context)
                              .getColleguesFromUser(uid),
                          title: 'Collegues',
                        ),
                        _localDivider,
                        _preWidgetCountUsers(
                          context,
                          future: FirebaseService.of(context)
                              .getFollowersFromUser(uid),
                          title: 'Followers',
                        ),
                        _localDivider,
                        _preWidgetCountUsers(
                          context,
                          future: FirebaseService.of(context)
                              .getFollowingFromUser(uid),
                          title: 'Following',
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('uid', uid));
  }
}
