import 'package:flutter/material.dart';
import 'package:notify/src/pages/additional/list_notifications_view.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchView extends StatefulWidget {
  static const String routeName = '/search_view';
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.search_hint,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, _) {
              if (value.text.trim().isEmpty) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_outlined),
                        Text(
                          AppLocalizations.of(context)!.enterToSearch,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () => Navigator.of(context)
                          .pushNamed(ListUsersView.routeName, arguments: {
                        'title': AppLocalizations.of(context)!
                            .usersWithWord(value.text),
                        'callback': () =>
                            ApiService.search.fromUsers(pattern: value.text)
                      }),
                      title: Text(AppLocalizations.of(context)!
                          .usersWithWord(value.text)),
                      leading: const Icon(Icons.person_search_outlined),
                      minLeadingWidth: 0,
                      trailing: const Icon(Icons.navigate_next_outlined),
                    ),
                    ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                          ListNotificationsView.routeName,
                          arguments: {
                            'title': AppLocalizations.of(context)!
                                .notificationsWithWord(value.text),
                            'callback': () => ApiService.search
                                .fromNotifications(pattern: value.text)
                          }),
                      title: Text(AppLocalizations.of(context)!
                          .notificationsWithWord(value.text)),
                      leading: const Icon(Icons.list_alt),
                      minLeadingWidth: 0,
                      trailing: const Icon(Icons.navigate_next_outlined),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
