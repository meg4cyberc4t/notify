import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/view_models/user_list_tile.dart';
import 'package:notify/src/models/notify_user_quick.dart';

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
      body: LocalFutureBuilder<List<NotifyUserQuick>>(
        future: widget.callback(),
        onError: (BuildContext context, Object error) {
          debugPrint(error.toString());
          return const Center(
            child: Text('Error'),
          );
        },
        onProgress: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
        onData: (BuildContext context, List<NotifyUserQuick> users) =>
            ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => UserListTile(
            user: users[index],
            onTap: widget.onSelect,
          ),
        ),
      ),
    );
  }
}
