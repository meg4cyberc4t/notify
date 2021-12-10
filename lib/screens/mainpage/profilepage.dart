import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/components/widgets/direct_button.dart';
import 'package:notify/components/widgets/progress_indicator.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userUID}) : super(key: key);
  final String userUID;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bool isMe = context.watch<User>().uid == widget.userUID;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userUID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: NotifyProgressIndicator(),
              );
            } else if (!snapshot.data!.exists) {
              return const Center(
                child: Text("User does not exist"),
              );
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
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    NotifyAlertDialogButtonItem(
                                      title: "Next",
                                      onPressed: () {
                                        context
                                            .read<AuthenticationService>()
                                            .signOut();
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                              // context.read<AuthenticationService>().signOut();
                            })
                        : IconButton(
                            icon: const Icon(CupertinoIcons.add),
                            onPressed: () {},
                          ),
                  ],
                  leading: isMe
                      ? IconButton(
                          icon: const Icon(CupertinoIcons.pen),
                          onPressed: () async {
                            final Color? inputColor = await Navigator.push(
                              context,
                              Platform.isAndroid
                                  ? MaterialPageRoute(
                                      builder: (context) => ColorPickerPage(
                                        title: (data['first_name'][0] +
                                                data['last_name'][0])
                                            .toUpperCase(),
                                        initialValue: userColor,
                                      ),
                                    )
                                  : CupertinoPageRoute(
                                      builder: (context) => ColorPickerPage(
                                        title: (data['first_name'][0] +
                                                data['last_name'][0])
                                            .toUpperCase(),
                                        initialValue: userColor,
                                      ),
                                    ),
                            );
                            if (inputColor != null) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userUID)
                                  .update({
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
                    background: Container(
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
                        onPressed: () {
                          Navigator.pushNamed(context, "/ProfilePageEdit");
                        },
                      )),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: NotifyDirectButton.icon(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('relations')
                                  .add({
                                "from": "",
                                "to": "",
                              });
                            },
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
                          onPressed: () async {
                            var snapshot = await FirebaseFirestore.instance
                                .collection('relations')
                                .where("to",
                                    isEqualTo: "xaNIHsf1ducwAiQ1IYngtgpEE5u2")
                                .get();
                            print(snapshot.docs[0].data());
                          },
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          text: 'QR code',
                        ))
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 1000),
                )
              ],
            );
          }),
    );
  }
}
