import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/methods/get_theme_mode_title.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/settings/about_view.dart';
import 'package:notify/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);
  static const String routeName = 'settings_view';

  Widget get separator => const Divider(
        height: 2,
        thickness: 4,
      );

  @override
  Widget build(BuildContext context) {
    _localHeadline(String headline) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            child: Text(
              headline,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        );
// AppLocalizations.of(context)!
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Wrap(
        children: [
          _localHeadline(AppLocalizations.of(context)!.settingsMain),
          ListTile(
            title: Text(AppLocalizations.of(context)!.applicationTheme),
            subtitle: Text(getThemeModeTitle(context,
                Provider.of<ThemeNotifier>(context, listen: false).themeMode)),
            onTap: () {
              int value = Provider.of<ThemeNotifier>(context, listen: false)
                      .themeMode
                      .index +
                  1;
              if (value == 3) {
                value = 0;
              }
              Provider.of<ThemeNotifier>(context, listen: false).themeMode =
                  ThemeMode.values[value];
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.logout,
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            onTap: () async {
              while (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context)
                  .popAndPushNamed(AuthPreview.routeName);
            },
          ),
          separator,
          _localHeadline(AppLocalizations.of(context)!.settingsAdditional),
          ListTile(
            onTap: () => Navigator.of(context).pushNamed(AboutView.routeName),
            title: Text(AppLocalizations.of(context)!.aboutApp),
            leading: const Icon(Icons.info),
            minLeadingWidth: 0,
          ),
        ],
      ),
    );
  }
}
