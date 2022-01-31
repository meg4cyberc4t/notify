import 'package:flutter/material.dart';
import 'package:notify/components/bottomsheets/show_logout_alert_dialog.dart';
import 'package:notify/components/builders/custom_future_builder.dart';
import 'package:notify/services/firebase_service.dart';
// ignore_for_file: public_member_api_docs

class BlankPage extends StatelessWidget {
  const BlankPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomFutureBuilder<String>.notify(
                future: FirebaseService.auth.currentUser!.getIdToken(),
                onData: (
                  final BuildContext context,
                  final String data,
                ) =>
                    Text(data),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async => showLogoutAlertDialog(context),
              ),
            ],
          ),
        ),
      );
}
