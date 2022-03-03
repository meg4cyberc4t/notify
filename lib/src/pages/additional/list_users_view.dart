import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/get_passive_color.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/pages/profile/profile_view.dart';

class ListUsersView extends StatefulWidget {
  const ListUsersView({
    Key? key,
    required this.title,
    required this.callback,
  }) : super(key: key);

  static const String routeName = 'list_users_view';

  final String title;
  final Future<List<NotifyUserQuick>> Function() callback;

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
        onProgress: (BuildContext context) => Center(
          child: LocalSplitter.withShimmer(
            context: context,
            isLoading: true,
            child: const CircularProgressIndicator(),
          ),
        ),
        onData: (BuildContext context, List<NotifyUserQuick> users) =>
            ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return ListTile(
                    onTap: () => Navigator.of(context)
                        .pushNamed(ProfileView.routeName, arguments: {
                      'id': user.id,
                      'preTitle': user.title,
                    }),
                    leading: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      decoration: BoxDecoration(
                        color: user.color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: Text(
                        user.shortTitle,
                        style: TextStyle(color: getPassiveColor(user.color)),
                      )),
                      height: 40,
                      width: 40,
                    ),
                    title: Text(user.title),
                    subtitle: Text(
                      user.status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
      ),
    );
  }
}
