import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/bottomsheets/show_users_bottom_sheet.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/progress_indicator.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({this.uid, Key? key}) : super(key: key);
  final String? uid;

  void functionLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NotifyAlertDialog(
        title: 'Do you confirm the exit?',
        listButtons: [
          NotifyAlertDialogButtonItem(
            title: "Back",
            onPressed: () => Navigator.pop(context),
          ),
          NotifyAlertDialogButtonItem(
            title: "Next",
            onPressed: () {
              context.read<FirebaseService>().signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void functionFollowSwitch(BuildContext context) async {
    await context.read<FirebaseService>().followSwitch(uid!);
  }

  Widget rightUpButton(BuildContext context,
      {required bool isMe, required bool isFollowed}) {
    if (isMe) {
      return IconButton(
        icon: const Icon(
          Icons.logout,
        ),
        onPressed: () => functionLogout(context),
      );
    } else {
      return IconButton(
        icon: Icon(isFollowed ? CupertinoIcons.minus : CupertinoIcons.add),
        onPressed: () => functionFollowSwitch(context),
      );
    }
  }

  Widget? leftUpButton(BuildContext context,
      {required bool isMe,
      required String title,
      required Color userColor,
      required String uid}) {
    if (isMe) {
      return IconButton(
        icon: const Icon(CupertinoIcons.pen),
        onPressed: () async {
          final Color? inputColor = await Navigator.push(
              context,
              Platform.isAndroid
                  ? MaterialPageRoute(
                      builder: (context) => ColorPickerPage(
                            title: title,
                            initialValue: userColor,
                          ))
                  : CupertinoPageRoute(
                      builder: (context) => ColorPickerPage(
                            title: title,
                            initialValue: userColor,
                          )));
          if (inputColor != null) {
            context.read<FirebaseService>().updateInfoAboutUser(uid, {
              "color_r": inputColor.red,
              "color_g": inputColor.green,
              "color_b": inputColor.blue,
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String meUID = context.watch<User>().uid;
    final String profileUID = uid ?? meUID;
    final bool isMe = meUID == profileUID;
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: context
            .read<FirebaseService>()
            .checkFollowed(context.watch<User>().uid, profileUID),
        builder: (context, isFollowedSnapshot) =>
            snapshotMiddleware(isFollowedSnapshot) ??
            StreamBuilder<DocumentSnapshot>(
              stream:
                  context.read<FirebaseService>().getInfoAboutUser(profileUID),
              builder: (context, snapshot) {
                Widget? widget = snapshotMiddleware(snapshot) ??
                    checkSnapshotDataExist(snapshot);
                if (widget != null) {
                  return widget;
                }
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                Color userColor = Color.fromRGBO(
                  data['color_r'],
                  data['color_g'],
                  data['color_b'],
                  1,
                );

                Color passiveColor =
                    ThemeData.estimateBrightnessForColor(userColor) ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white;

                bool isFollowed = isFollowedSnapshot.data!;

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 8,
                      centerTitle: true,
                      primary: true,
                      iconTheme: IconThemeData(color: passiveColor),
                      actions: [
                        rightUpButton(context,
                            isMe: isMe, isFollowed: isFollowed),
                      ],
                      leading: leftUpButton(context,
                          isMe: isMe,
                          title: (data['first_name'][0] + data['last_name'][0])
                              .toUpperCase(),
                          uid: meUID,
                          userColor: userColor),
                      expandedHeight: 300,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          data['first_name'] + " " + data['last_name'],
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: passiveColor),
                        ),
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                        background: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color: userColor,
                        ),
                      ),
                      pinned: true,
                      backgroundColor: userColor,
                    ),
                    if (data['status'].isNotEmpty)
                      statusWidget(context, data['status']),
                    middleDirectButtonWidget(context,
                        isMe: isMe, isFollowed: isFollowed),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            colleguesFromUserWidget(context, profileUID),
                            _localDivider(context),
                            followersFromUsersWidget(context, profileUID),
                            _localDivider(context),
                            followingFromUsersWidget(context, profileUID),
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

  SliverToBoxAdapter middleDirectButtonWidget(BuildContext context,
      {required bool isMe, required bool isFollowed}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: isMe
            ? NotifyDirectButton(
                title: 'Edit',
                style: NotifyDirectButtonStyle.outlined,
                onPressed: () async =>
                    await Navigator.pushNamed(context, "/ProfilePageEdit"),
              )
            : NotifyDirectButton(
                title: isFollowed ? 'Remove' : 'Add',
                style: isFollowed
                    ? NotifyDirectButtonStyle.outlined
                    : NotifyDirectButtonStyle.primary,
                onPressed: () => functionFollowSwitch(context),
              ),
      ),
    );
  }

  SliverToBoxAdapter statusWidget(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Expanded colleguesFromUserWidget(BuildContext context, String uid) {
    return Expanded(
      child: StreamBuilder(
          stream: context.read<FirebaseService>().getColleguesFromUser(uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              List<String> data = snapshot.data as List<String>;
              return InkWell(
                onTap: () => showUsersBottomSheet(context, data),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.length.toString(),
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      'Collegues',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              );
            }
            return const NotifyProgressIndicator();
          }),
    );
  }

  Expanded followersFromUsersWidget(BuildContext context, String profileUID) {
    return Expanded(
      child: StreamBuilder(
          stream: context.read<FirebaseService>().getFollowersFromUser(
                profileUID,
              ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              List<String> data = snapshot.data as List<String>;
              return InkWell(
                onTap: () => showUsersBottomSheet(context, data),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.length.toString(),
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      'Followers',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              );
            }
            return const NotifyProgressIndicator();
          }),
    );
  }

  Expanded followingFromUsersWidget(BuildContext context, String profileUID) {
    return Expanded(
      child: StreamBuilder(
          stream:
              context.read<FirebaseService>().getFollowingFromUser(profileUID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              List<String> data = snapshot.data as List<String>;
              return InkWell(
                onTap: () => showUsersBottomSheet(context, data),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.length.toString(),
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      'Following',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              );
            }
            return const NotifyProgressIndicator();
          }),
    );
  }

  Container _localDivider(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey,
    );
  }
}
