import 'package:flutter/material.dart';
import 'package:notify/components/snapshot_middleware.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
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
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Search'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: NotifyTextField(
                autocorrect: true,
                hintText: 'Search everyone...',
                controller: controller,
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          FutureBuilder(
              key: futureBuilderForSearch,
              future: context
                  .read<FirebaseService>()
                  .searchFromUsers(controller.text.trim()),
              builder: (context, snapshot) {
                var widget = snapshotMiddleware(snapshot);
                if (widget != null) {
                  return SliverToBoxAdapter(child: widget);
                }
                var state = snapshot.data as List<String>;
                if (state.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No found',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
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
                        return SliverToBoxAdapter(child: widget);
                      }
                      List<NotifyUser> data = snapshot.data as List<NotifyUser>;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => Column(
                                  children: [
                                    NotifyUserListTile(
                                      user: data[index],
                                      key: Key(data[index].uid),
                                    ),
                                    if (index != data.length - 1)
                                      Divider(
                                          indent: 80,
                                          height: 0.5,
                                          color:
                                              Theme.of(context).dividerColor),
                                  ],
                                ),
                            childCount: data.length),
                      );
                    });
              }),
        ],
      ),
    );
  }
}
