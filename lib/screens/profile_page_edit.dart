// ignore_for_file: public_member_api_docs, prefer_single_quotes

 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/static_methods/snapshot_middleware.dart';
import 'package:provider/provider.dart';

class ProfilePageEdit extends StatefulWidget {
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
          child: StreamBuilder<NotifyUser>(
            stream: FirebaseService.of(context)
                .getInfoAboutUser(context.watch<User>().uid),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<NotifyUser> snapshot,
            ) {
              final Widget? widget = snapshotMiddleware(snapshot);
              if (widget != null) {
                return widget;
              }

              final NotifyUser user = snapshot.data!;
              _controllerFirstname.text = user.firstName;
              _controllerLastname.text = user.lastName;
              _controllerStatus.text = user.status;

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
                        child: NotifyDirectButton(
                          title: 'Back',
                          onPressed: () => Navigator.pop(context),
                          style: NotifyDirectButtonStyle.outlined,
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
