import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/get_passive_color.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/profile/my_profile_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/settings_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    required this.id,
    this.preTitle,
    Key? key,
  }) : super(key: key);
  static const routeName = 'profile_view';
  final String id;
  final String? preTitle;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'profile_view');
  final ScrollController _scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    if (widget.id == SettingsService.instance.userId()) {
      return const MyProfileView();
    }
    super.build(context);
    return Scaffold(
      restorationId: 'profile_view',
      key: _scaffoldKey,
      body: LocalFutureBuilder.withLoading<NotifyUserDetailed>(
        future: ApiService.users.get(widget.id),
        onError: (BuildContext context, Object err) =>
            Center(child: Text(err.toString())),
        onLoading:
            (BuildContext context, NotifyUserDetailed? user, bool isLoaded) =>
                CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                  color: getPassiveColor(
                user?.color ?? Theme.of(context).primaryColor,
              )),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: LocalSplitter.withShimmer(
                    context: context,
                    isLoading: !isLoaded,
                    child: Text(
                      user?.title ?? 'Загрузка',
                      style: TextStyle(
                          color: user?.color != null
                              ? getPassiveColor(user!.color)
                              : null),
                    )),
                background: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  color: user?.color ?? Theme.of(context).primaryColor,
                ),
              ),
              pinned: true,
              backgroundColor: user?.color ?? Theme.of(context).primaryColor,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: LocalSplitter.withShimmer(
                    context: context,
                    isLoading: !isLoaded,
                    child: Text(
                      user?.status ?? '...',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    )),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              sliver: SliverToBoxAdapter(
                child: LocalSplitter.withShimmer(
                    context: context,
                    isLoading: !isLoaded,
                    child: Builder(
                      builder: (BuildContext context) {
                        if (!isLoaded) {
                          return const TextButton(
                            child: Text('Загрузка'),
                            onPressed: null,
                          );
                        } else if (user!.follow) {
                          return OutlinedButton(
                            child: const Text('Unfollow'),
                            onPressed: () async {
                              if (!isLoaded) return;
                              await ApiService.user
                                  .changeSubscription(widget.id);
                              setState(() {});
                            },
                          );
                        }
                        return ElevatedButton(
                          child: const Text('Follow'),
                          onPressed: () async {
                            if (!isLoaded) return;
                            await ApiService.user.changeSubscription(widget.id);
                            setState(() {});
                          },
                        );
                      },
                    )),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              sliver: SliverToBoxAdapter(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        callback() => ApiService.users.subscribers(widget.id);
                        await Navigator.of(context)
                            .pushNamed(ListUsersView.routeName, arguments: {
                          'title': 'Subscribers',
                          'callback': callback,
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
                        child: LocalSplitter.withShimmer(
                          isLoading: !isLoaded,
                          context: context,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    user?.subscribersCount.toString() ?? '0',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              Text(
                                'Subscribers',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        callback() => ApiService.users.subscriptions(widget.id);
                        await Navigator.of(context)
                            .pushNamed(ListUsersView.routeName, arguments: {
                          'title': 'Subscriptions',
                          'callback': callback,
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
                        child: LocalSplitter.withShimmer(
                          isLoading: !isLoaded,
                          context: context,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    user?.subscriptionsCount.toString() ?? '0',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              Text(
                                'Subscriptions',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
                        child: LocalSplitter.withShimmer(
                          isLoading: !isLoaded,
                          context: context,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    Icons.add_alert,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .color,
                                    semanticLabel: 'Add notification',
                                    size: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .fontSize! -
                                        8,
                                  ),
                                ),
                              ),
                              Text(
                                'Remind',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
