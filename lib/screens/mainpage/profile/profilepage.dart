import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/bottomsheets/show_users_bottom_sheet.dart';
import 'package:notify/components/methods/custom_route.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/configs/notify_parameters.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({this.uid, Key? key}) : super(key: key);
  final String? uid;

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

                Widget _logoutButton = IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseService.of(context).signOut(),
                );

                Widget _followSwitch = IconButton(
                  icon: Icon(
                      isFollowed ? CupertinoIcons.minus : CupertinoIcons.add),
                  onPressed: () =>
                      FirebaseService.of(context).followSwitch(uid!),
                );

                Widget _editColorButton = IconButton(
                  icon: const Icon(CupertinoIcons.pen),
                  onPressed: () async {
                    final Color? inputColor = await Navigator.push(
                        context,
                        customRoute(ColorPickerPage(
                          title: (data['first_name'][0] + data['last_name'][0])
                              .toUpperCase(),
                          initialValue: userColor,
                        )));
                    if (inputColor != null) {
                      context
                          .read<FirebaseService>()
                          .updateInfoAboutUser(meUID, {
                        "color_r": inputColor.red,
                        "color_g": inputColor.green,
                        "color_b": inputColor.blue,
                      });
                    }
                  },
                );

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 8,
                      centerTitle: true,
                      primary: true,
                      iconTheme: IconThemeData(color: passiveColor),
                      actions: [(isMe) ? _logoutButton : _followSwitch],
                      leading: (isMe) ? _editColorButton : null,
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
                          duration: NotifyParameters.duration,
                          color: userColor,
                        ),
                      ),
                      pinned: true,
                      backgroundColor: userColor,
                    ),
                    if (data['status'].isNotEmpty)
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
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                          child: isMe
                              ? NotifyDirectButton(
                                  title: 'Edit',
                                  style: NotifyDirectButtonStyle.outlined,
                                  onPressed: () async =>
                                      await Navigator.pushNamed(
                                          context, "/ProfilePageEdit"),
                                )
                              : NotifyDirectButton(
                                  title: isFollowed ? 'Remove' : 'Add',
                                  style: isFollowed
                                      ? NotifyDirectButtonStyle.outlined
                                      : NotifyDirectButtonStyle.primary,
                                  onPressed: () => FirebaseService.of(context)
                                      .followSwitch(profileUID),
                                )),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            preWidgetCountUsers(context,
                                stream: FirebaseService.of(context)
                                    .getColleguesFromUser(profileUID),
                                title: "Collegues"),
                            _localDivider(context),
                            preWidgetCountUsers(context,
                                stream: FirebaseService.of(context)
                                    .getFollowersFromUser(profileUID),
                                title: "Followers"),
                            _localDivider(context),
                            preWidgetCountUsers(context,
                                stream: FirebaseService.of(context)
                                    .getFollowingFromUser(profileUID),
                                title: "Followers"),
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

  Expanded preWidgetCountUsers(BuildContext context,
      {required Stream<List<String>> stream, required String title}) {
    return Expanded(
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              List<String> data = snapshot.data as List<String>;
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => showUsersBottomSheet(context, data),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  strokeWidth: NotifyParameters.circularProgressIndicatorWidth),
            );
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
