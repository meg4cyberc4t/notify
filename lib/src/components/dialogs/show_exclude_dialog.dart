import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T?> showExcludeDialog<T>({
  required BuildContext context,
  required String title,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.exclude),
      content: Text(AppLocalizations.of(context)!.excludeMessage(title)),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.no),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.yes),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
