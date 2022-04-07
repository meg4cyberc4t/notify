import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';

class ListUsersView extends StatefulWidget {
  const ListUsersView({
    Key? key,
    required this.title,
    required this.callback,
    this.onSelect,
  }) : super(key: key);

  static const String routeName = 'list_users_view';

  final String title;
  final Future<List<NotifyUserQuick>> Function() callback;
  final Function(NotifyUserQuick e)? onSelect;

  @override
  State<ListUsersView> createState() => _ListUsersViewState();
}

class _ListUsersViewState extends State<ListUsersView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Consumer<CustomListViewLocalState>(
        builder: (context, _, __) => LocalFutureBuilder<List<NotifyUserQuick>>(
            future: widget.callback(),
            onProgress: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()),
            onData: (BuildContext context, List<NotifyUserQuick> users) {
              if (users.isEmpty) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_outlined),
                        Text(
                          AppLocalizations.of(context)!.notFound,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => UserListTile(
                  user: users[index],
                  onTap: widget.onSelect,
                ),
              );
            }),
      ),
    );
  }
}
