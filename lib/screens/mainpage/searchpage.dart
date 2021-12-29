import 'package:flutter/material.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/components/widgets/notify_user_list_tile.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController controller = TextEditingController();
  GlobalKey futureBuilderForSearch = GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.headline3,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: NotifyTextField(
                    autocorrect: true,
                    hintText: 'Search everyone...',
                    controller: controller,
                    onChanged: (value) => setState(() {}),
                  ),
                )),
          ),
          Expanded(
            child: FutureBuilder(
                key: futureBuilderForSearch,
                future: context
                    .read<FirebaseService>()
                    .searchFromUsers(controller.text.trim()),
                builder: (context, snapshot) {
                  var widget = snapshotMiddleware(snapshot);
                  if (widget != null) {
                    return widget;
                  }
                  var state = snapshot.data as List<String>;
                  if (state.isEmpty) {
                    return Center(
                      child: Text(
                        'No found',
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
                                .map((user) => NotifyUserListTile(
                                      user: user,
                                      key: Key(user.uid),
                                    ))
                                .toList());
                      });
                }),
          ),
        ],
      ),
    );
  }
}
