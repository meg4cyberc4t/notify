import 'package:flutter/material.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/services/firebase_service.dart';

void showLogoutAlertDialog(BuildContext context) {
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
            FirebaseService.of(context).signOut();
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}
