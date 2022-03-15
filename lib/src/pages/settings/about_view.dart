import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);
  static const routeName = 'about_view';

  static const String _codeUrl = 'https://github.com/meg4cyberc4t/notify';
  static const String _releasesUrl =
      'https://github.com/meg4cyberc4t/notify/releases/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: LocalFutureBuilder(
        future: PackageInfo.fromPlatform(),
        onProgress: (_) => const Center(child: CircularProgressIndicator()),
        onError: (_, err) => Center(child: Text(err.toString())),
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
                onTap: () => launch(_codeUrl),
                title: Text(
                  'Приложение: ${info.appName}',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  info.packageName,
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                onTap: () => launch(_releasesUrl),
                title: Text(
                  'Версия: ${info.version}+${info.buildNumber}',
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
