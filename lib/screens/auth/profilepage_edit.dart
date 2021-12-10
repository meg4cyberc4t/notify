import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notify/components/widgets/direct_button.dart';
import 'package:notify/components/widgets/progress_indicator.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:provider/provider.dart';

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(context.watch<User>().uid)
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
              _controllerFirstname.text = data['first_name'];
              _controllerLastname.text = data['last_name'];
              _controllerStatus.text = data['status'];

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Text(
                        "Edit profile",
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
                            horizontal: 8.0, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: NotifyDirectButton.text(
                              text: 'Save',
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(Provider.of<User>(context,
                                            listen: false)
                                        .uid)
                                    .update({
                                  "first_name": _controllerFirstname.text,
                                  "last_name": _controllerLastname.text,
                                  "status": _controllerStatus.text
                                });
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: NotifyDirectButton.text(
                              text: 'Back',
                              onPressed: () => Navigator.pop(context),
                              isOutlined: true,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
