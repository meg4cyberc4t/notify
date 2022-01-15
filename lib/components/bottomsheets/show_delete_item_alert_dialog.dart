import 'package:flutter/material.dart';
import 'package:notify/components/widgets/alert_dialog.dart';
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/firebase_service.dart';

///  This is a function of calling [NotifyAlertDialog] with confirmation
///  for the user whether he wants to log out.
Future<T?> showDeleteItemAlertDialog<T>(
  final BuildContext context,
  final NotifyNotification ntf,
) =>
    showDialog<T?>(
      context: context,
      builder: (final BuildContext context) => NotifyAlertDialog(
        title: 'Exactly delete "${ntf.title}"?',
        buttons: <NotifyAlertDialogButtonItem>[
          NotifyAlertDialogButtonItem(
            title: 'Back',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          NotifyAlertDialogButtonItem(
            title: 'Next',
            onPressed: () {
              FirebaseService.deleteNotification(ntf);
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
