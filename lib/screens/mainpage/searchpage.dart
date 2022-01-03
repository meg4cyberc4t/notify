// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notify/components/methods/snapshot_middleware.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/components/widgets/notify_user_list_tile.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_user.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({final Key? key}) : super(key: key);

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
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
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
                onChanged: (final String? value) => setState(() {}),
              ),
            ),
          ),
          FutureBuilder<List<String>>(
            key: futureBuilderForSearch,
            future: context
                .read<FirebaseService>()
                .searchFromUsers(controller.text.trim()),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<List<String>> snapshot,
            ) {
              final Widget? widget = snapshotMiddleware(snapshot);
              if (widget != null) {
                return SliverToBoxAdapter(child: widget);
              }
              final List<String> state = snapshot.data!;
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
              return StreamBuilder<List<NotifyUser>>(
                stream: context
                    .read<FirebaseService>()
                    .getUsersListFromUsersUidList(state),
                builder: (
                  final BuildContext context,
                  final AsyncSnapshot<List<NotifyUser>> snapshot,
                ) {
                  final Widget? widget = snapshotMiddleware(snapshot);
                  if (widget != null) {
                    return SliverToBoxAdapter(child: widget);
                  }
                  final List<NotifyUser> data = snapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (final BuildContext context, final int index) => Column(
                        children: <Widget>[
                          NotifyUserListTile(
                            user: data[index],
                            key: Key(data[index].uid),
                          ),
                          if (index != data.length - 1)
                            Divider(
                              indent: 80,
                              height: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                        ],
                      ),
                      childCount: data.length,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(
        DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>(
          'futureBuilderForSearch',
          futureBuilderForSearch,
        ),
      );
  }
}
