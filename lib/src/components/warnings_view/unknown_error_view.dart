import 'package:flutter/material.dart';
import 'package:notify/src/pages/settings/about_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnknownErrorView extends StatelessWidget {
  const UnknownErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline_outlined,
                size: Theme.of(context).textTheme.headline5!.fontSize,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.unknownError,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.unknownErrorDevMessage,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () async => launch(AboutView.newIssueUrl),
                child: Text(
                  AppLocalizations.of(context)!.reportBug,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
