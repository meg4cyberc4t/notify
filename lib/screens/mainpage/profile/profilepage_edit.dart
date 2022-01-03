// ignore_for_file: prefer_single_quotes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/methods/snapshot_middleware.dart';

import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

/// A page that allows you to change the information of the current user
class ProfilePageEdit extends StatefulWidget {
  /// The main screen constructor
  const ProfilePageEdit({final Key? key}) : super(key: key);

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerStatus = TextEditingController();

  @override
  void dispose() {
    _controllerFirstname.dispose();
    _controllerLastname.dispose();
    _controllerStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: context
                .read<FirebaseService>()
                .getInfoAboutUser(context.watch<User>().uid),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                  snapshot,
            ) {
              final Widget? widget = snapshotMiddleware(snapshot);
              if (widget != null) {
                return widget;
              }
              if (snapshot.data!.exists) {
                return const SizedBox.expand(
                  child: Center(
                    child: Text("Data does not exist"),
                  ),
                );
              }

              final Map<String, dynamic> data = snapshot.data!.data()!;
              _controllerFirstname.text = data['first_name'];
              _controllerLastname.text = data['last_name'];
              _controllerStatus.text = data['status'];

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Text(
                        // TODO: Rewrite profile_page edit with new AppBar
                        'Edit profile',
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      NotifyTextField(
                        hintText: 'Your first name',
                        labelText: 'First name',
                        controller: _controllerFirstname,
                      ),
                      const SizedBox(height: 10),
                      NotifyTextField(
                        hintText: 'Your last name',
                        labelText: 'Last name',
                        controller: _controllerLastname,
                      ),
                      const SizedBox(height: 30),
                      NotifyTextField(
                        labelText: 'Your status',
                        controller: _controllerStatus,
                        minLines: 5,
                        maxLines: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: NotifyDirectButton(
                                title: 'Save',
                                onPressed: () {
                                  FirebaseService.of(context)
                                      .updateInfoAboutUser(<String, String>{
                                    'first_name': _controllerFirstname.text,
                                    'last_name': _controllerLastname.text,
                                    'status': _controllerStatus.text
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: NotifyDirectButton(
                                title: 'Back',
                                onPressed: () => Navigator.pop(context),
                                style: NotifyDirectButtonStyle.outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
