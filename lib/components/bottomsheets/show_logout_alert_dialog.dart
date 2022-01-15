import 'package:flutter/material.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/services/firebase_service.dart';

///  This is a function of calling [NotifyAlertDialog] with confirmation
///  for the user whether he wants to log out.
Future<void> showLogoutAlertDialog(final BuildContext context) => showDialog(
      context: context,
      builder: (final BuildContext context) => NotifyAlertDialog(
        title: 'Do you confirm the exit?',
        buttons: <NotifyAlertDialogButtonItem>[
          NotifyAlertDialogButtonItem(
            title: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
          NotifyAlertDialogButtonItem(
            title: 'Next',
            onPressed: () {
              FirebaseService.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
