import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/bottomsheets/show_users_bottom_sheet.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/components/widgets/direct_button.dart';
import 'package:notify/components/widgets/progress_indicator.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.userUID}) : super(key: key);
  final String userUID;

  @override
  Widget build(BuildContext context) {
    final bool isMe = context.watch<User>().uid == userUID;

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: context
              .read<FirebaseService>()
              .checkFollowed(context.watch<User>().uid, userUID),
          builder: (context, isFollowedSnapshot) =>
              snapshotMiddleware(isFollowedSnapshot) ??
              StreamBuilder<DocumentSnapshot>(
                  stream:
                      context.read<FirebaseService>().getInfoAboutUser(userUID),
                  builder: (context, snapshot) {
                    Widget? widget = snapshotMiddleware(snapshot);
                    if (widget != null) {
                      return widget;
                    }
                    widget = checkSnapshotDataExist(snapshot);
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
                            isMe
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.logout,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => NotifyAlertDialog(
                                          title: 'Do you confirm the exit?',
                                          listButtons: [
                                            NotifyAlertDialogButtonItem(
                                              title: "Back",
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            NotifyAlertDialogButtonItem(
                                              title: "Next",
                                              onPressed: () {
                                                context
                                                    .read<FirebaseService>()
                                                    .signOut();
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    })
                                : IconButton(
                                    icon: Icon(isFollowed
                                        ? CupertinoIcons.minus
                                        : CupertinoIcons.add),
                                    onPressed: () async {
                                      await context
                                          .read<FirebaseService>()
                                          .followSwitch(userUID);
                                    }),
                          ],
                          leading: isMe
                              ? IconButton(
                                  icon: const Icon(CupertinoIcons.pen),
                                  onPressed: () async {
                                    final Color? inputColor =
                                        await Navigator.push(
                                            context,
                                            Platform.isAndroid
                                                ? MaterialPageRoute(
                                                    builder: (context) =>
                                                        ColorPickerPage(
                                                          title: (data['first_name']
                                                                      [0] +
                                                                  data['last_name']
                                                                      [0])
                                                              .toUpperCase(),
                                                          initialValue:
                                                              userColor,
                                                        ))
                                                : CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ColorPickerPage(
                                                          title: (data['first_name']
                                                                      [0] +
                                                                  data['last_name']
                                                                      [0])
                                                              .toUpperCase(),
                                                          initialValue:
                                                              userColor,
                                                        )));
                                    if (inputColor != null) {
                                      context
                                          .read<FirebaseService>()
                                          .updateInfoAboutUser(userUID, {
                                        "color_r": inputColor.red,
                                        "color_g": inputColor.green,
                                        "color_b": inputColor.blue,
                                      });
                                    }
                                  })
                              : IconButton(
                                  icon: const Icon(CupertinoIcons.qrcode),
                                  onPressed: () {},
                                ),
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
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Text(
                              data['status'],
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: NotifyDirectButton.text(
                                text: 'Edit',
                                isOutlined: true,
                                onPressed: () => Navigator.pushNamed(
                                    context, "/ProfilePageEdit"),
                              )),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 10),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: StreamBuilder(
                                      stream: context
                                          .read<FirebaseService>()
                                          .getColleguesFromUser(userUID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        if (snapshot.hasData) {
                                          List<String> data =
                                              snapshot.data as List<String>;
                                          return InkWell(
                                            onTap: () => showUsersBottomSheet(
                                                context, data),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.length.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                Text(
                                                  'Collegues',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const NotifyProgressIndicator();
                                      }),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                      stream: context
                                          .read<FirebaseService>()
                                          .getFollowersFromUser(userUID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        if (snapshot.hasData) {
                                          List<String> data =
                                              snapshot.data as List<String>;
                                          return InkWell(
                                            onTap: () => showUsersBottomSheet(
                                                context, data),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.length.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                Text(
                                                  'Followers',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const NotifyProgressIndicator();
                                      }),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                      stream: context
                                          .read<FirebaseService>()
                                          .getFollowingFromUser(userUID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        if (snapshot.hasData) {
                                          List<String> data =
                                              snapshot.data as List<String>;
                                          return InkWell(
                                            onTap: () => showUsersBottomSheet(
                                                context, data),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.length.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                Text(
                                                  'Following',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const NotifyProgressIndicator();
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 10),
                        ),
                        // NOTE: QR code
                        // SliverToBoxAdapter(
                        //   child: Column(
                        //     children: [
                        //       QrImage(
                        //         data: userUID,
                        //         version: QrVersions.auto,
                        //         size: 150,
                        //         gapless: true,
                        //       ),
                        //       Text(
                        //         'Scan this QR code from another device to find this account!',
                        //         style: Theme.of(context).textTheme.headline6,
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SliverToBoxAdapter(
                        //   child: SizedBox(height: 10),
                        // ),
                      ],
                    );
                  })),
    );
  }
}
