import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);
  static const routeName = 'about_view';

  static const String codeUrl = 'https://github.com/meg4cyberc4t/notify';
  static const String releasesUrl =
      'https://github.com/meg4cyberc4t/notify/releases/';
  static const String newIssueUrl =
      'https://github.com/meg4cyberc4t/notify/issues/new';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutApp),
      ),
      body: LocalFutureBuilder(
        future: PackageInfo.fromPlatform(),
        onProgress: (_) => const Center(child: CircularProgressIndicator()),
        onData: (context, PackageInfo info) {
          return Column(
            children: [
              SizedBox(
                child: Center(
                  child: Image.asset('assets/images/icon.png'),
                ),
                height: 200,
              ),
              ListTile(
                onTap: () => launch(codeUrl),
                title: Text(
                  info.appName,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  info.packageName,
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                onTap: () => launch(releasesUrl),
                title: Text(
                  AppLocalizations.of(context)!
                      .version(info.version, info.buildNumber),
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                onTap: () => launch(codeUrl),
                title: Text(
                  AppLocalizations.of(context)!.sourceCode,
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                onTap: () => launch(newIssueUrl),
                title: Text(
                  AppLocalizations.of(context)!.reportBug,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
