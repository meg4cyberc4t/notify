import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/methods/get_theme_mode_title.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/settings/about_view.dart';
import 'package:notify/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Wrap(
        children: [
          _localHeadline('Основные'),
          ListTile(
            title: const Text('Тема приложения'),
            subtitle: Text(getThemeModeTitle(
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
              'Выйти',
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
          _localHeadline('Дополнительно'),
          ListTile(
            onTap: () => Navigator.of(context).pushNamed(AboutView.routeName),
            title: const Text('О приложении'),
            leading: const Icon(Icons.info),
            minLeadingWidth: 0,
          ),
        ],
      ),
    );
  }
}
