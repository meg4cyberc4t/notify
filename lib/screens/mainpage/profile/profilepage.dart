// ignore_for_file: prefer_single_quotes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notify/components/bottomsheets/show_users_bottom_sheet.dart';
import 'package:notify/components/methods/custom_route.dart';
import 'package:notify/components/methods/snapshot_middleware.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/configs/notify_parameters.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';
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
    final String meUID = context.watch<User>().uid;
    final String profileUID = widget.uid ?? meUID;
    final bool isMe = meUID == profileUID;

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: context
            .read<FirebaseService>()
            .checkFollowed(context.watch<User>().uid, profileUID),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<bool> isFollowedSnapshot,
        ) =>
            snapshotMiddleware(isFollowedSnapshot) ??
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:
                  context.read<FirebaseService>().getInfoAboutUser(profileUID),
              builder: (
                final BuildContext context,
                final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot,
              ) {
                final Widget? widget = snapshotMiddleware(snapshot);
                if (widget != null) {
                  return widget;
                }
                if (!snapshot.data!.exists) {
                  return const SizedBox.expand(
                    child: Center(
                      child: Text("Data does not exist"),
                    ),
                  );
                }
                final Map<String, dynamic> data = snapshot.data!.data()!;
                final String userFirstname = data['first_name'];
                final String userLastname = data['last_name'];
                final String status = data['status'];
                final Color userColor = Color.fromRGBO(
                  data['color_r'],
                  data['color_g'],
                  data['color_b'],
                  1,
                );

                final Color passiveColor =
                    ThemeData.estimateBrightnessForColor(userColor) ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white;

                final bool isFollowed = isFollowedSnapshot.data!;

                final Widget _logoutButton = IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseService.of(context).signOut(),
                );

                final Widget _followSwitch = IconButton(
                  icon: Icon(
                    isFollowed ? CupertinoIcons.minus : CupertinoIcons.add,
                  ),
                  onPressed: () =>
                      FirebaseService.of(context).followSwitch(profileUID),
                );

                final Widget _editColorButton = IconButton(
                  icon: const Icon(CupertinoIcons.pen),
                  onPressed: () async {
                    final Color? inputColor = await Navigator.push(
                      context,
                      customRoute(
                        ColorPickerPage(
                          title: (userFirstname[0] + userLastname[0])
                              .toUpperCase(),
                          initialValue: userColor,
                        ),
                      ),
                    );
                    if (inputColor != null) {
                      if (mounted) {
                        await FirebaseService.of(context)
                            .updateInfoAboutUser(<String, dynamic>{
                          'color_r': inputColor.red,
                          'color_g': inputColor.green,
                          'color_b': inputColor.blue,
                        });
                      }
                    }
                  },
                );

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(color: passiveColor),
                      actions: <Widget>[
                        if (isMe) _logoutButton else _followSwitch
                      ],
                      leading: isMe ? _editColorButton : null,
                      expandedHeight: 300,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          '$userFirstname $userLastname',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: passiveColor),
                        ),
                        background: AnimatedContainer(
                          duration: NotifyParameters.duration,
                          color: userColor,
                        ),
                      ),
                      pinned: true,
                      backgroundColor: userColor,
                    ),
                    if (status.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            data['status'],
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: isMe
                            ? NotifyDirectButton(
                                title: 'Edit',
                                style: NotifyDirectButtonStyle.outlined,
                                onPressed: () async => Navigator.pushNamed(
                                  context,
                                  '/ProfilePageEdit',
                                ),
                              )
                            : NotifyDirectButton(
                                title: isFollowed ? 'Remove' : 'Add',
                                style: isFollowed
                                    ? NotifyDirectButtonStyle.outlined
                                    : NotifyDirectButtonStyle.primary,
                                onPressed: () => FirebaseService.of(context)
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
                            preWidgetCountUsers(
                              context,
                              stream: FirebaseService.of(context)
                                  .getColleguesFromUser(profileUID),
                              title: 'Collegues',
                            ),
                            _localDivider,
                            preWidgetCountUsers(
                              context,
                              stream: FirebaseService.of(context)
                                  .getFollowersFromUser(profileUID),
                              title: 'Followers',
                            ),
                            _localDivider,
                            preWidgetCountUsers(
                              context,
                              stream: FirebaseService.of(context)
                                  .getFollowingFromUser(profileUID),
                              title: 'Followers',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  ],
                );
              },
            ),
      ),
    );
  }

  Expanded preWidgetCountUsers(
    final BuildContext context, {
    required final Stream<List<String>> stream,
    required final String title,
  }) =>
      Expanded(
        child: StreamBuilder<List<String>>(
          stream: stream,
          builder: (
            final BuildContext context,
            final AsyncSnapshot<List<String>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final List<String> data = snapshot.data!;
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => showUsersBottomSheet(context, data),
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
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: NotifyParameters.circularProgressIndicatorWidth,
              ),
            );
          },
        ),
      );

  final Container _localDivider = Container(
    height: 50,
    width: 1,
    color: Colors.grey,
  );
}
