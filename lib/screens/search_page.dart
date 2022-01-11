// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notify/components/builders/custom_future_builder.dart';
import 'package:notify/components/widgets/notify_items_list.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
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
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(
              child: NotifyTextField(
                autocorrect: true,
                hintText: 'Search everyone...',
                controller: controller,
                onChanged: (final String? value) => setState(() {}),
              ),
            ),
          ),
          CustomFutureBuilder<List<String>>.notifySliver(
            key: futureBuilderForSearch,
            future: context
                .read<FirebaseService>()
                .searchFromUsers(controller.text.trim()),
            onData: (
              final BuildContext context,
              final List<String> state,
            ) {
              if (state.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'No found',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              return CustomFutureBuilder<List<NotifyUser>>.notifySliver(
                future: FirebaseService.of(context)
                    .getUsersListFromUsersUidList(state),
                onData: (
                  final BuildContext context,
                  final List<NotifyUser> list,
                ) =>
                    SliverNotifyItemsList(
                  list: list,
                ),
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
