import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/components/widgets/user_list_tile.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  List updateState(List state, dynamic action) {
    if (action is List) {
      state = action;
    }
    return state;
  }

  @override
  Widget build(BuildContext context) {
    final store = Store<List>(updateState, initialState: []);

    return StoreProvider<List>(
      store: store,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SearchTextField(
              onChanged: (value) async {
                var list = await context
                    .read<FirebaseService>()
                    .searchFromUsers(value.trim());
                store.dispatch(list);
              },
            ),
            Expanded(
              child: StoreConnector<List, List>(
                  converter: (store) => store.state,
                  builder: (context, List state) {
                    if (state is! List<String>) {
                      return Center(
                        child: Text(
                          'Enter something to search for',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return StreamBuilder(
                        stream: context
                            .read<FirebaseService>()
                            .getUsersListFromUsersUidList(state),
                        builder: (context, snapshot) {
                          var widget = snapshotMiddleware(snapshot);
                          if (widget != null) {
                            return widget;
                          }
                          List<NotifyUser> data =
                              snapshot.data as List<NotifyUser>;
                          return ListView(
                            children: data
                                .map((user) => NotifyUserListTile(user: user))
                                .toList(),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    this.onChanged,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: NotifyTextField(
              autocorrect: true,
              hintText: 'Search everyone...',
              onChanged: onChanged,
            ),
          )),
    );
  }
}
