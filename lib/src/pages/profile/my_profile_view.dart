import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:notify/src/pages/profile/edit_profile_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);
  static const routeName = 'my_profile_view';

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'profile_view');
  final ScrollController _scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      restorationId: 'my_profile_view',
      key: _scaffoldKey,
      body: LocalFutureBuilder.withLoading<NotifyUserDetailed>(
          future: ApiService.user.get(),
          onError: (BuildContext context, Object err) =>
              Center(child: Text(err.toString())),
          onLoading:
              (BuildContext context, NotifyUserDetailed? user, bool isLoaded) {
            if (isLoaded) {
              SettingsService.instance.updateUserId(user!.id);
            }
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  iconTheme: IconThemeData(
                      color: (user?.color ?? Theme.of(context).primaryColor)
                          .passive),
                  actions: <Widget>[
                    LocalSplitter.withShimmer(
                      context: context,
                      isLoading: !isLoaded,
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await Navigator.of(context)
                              .pushReplacementNamed(AuthPreview.routeName);
                        },
                      ),
                    ),
                  ],
                  leading: Navigator.of(context).canPop()
                      ? null
                      : LocalSplitter.withShimmer(
                          context: context,
                          isLoading: !isLoaded,
                          child: IconButton(
                            icon: const Icon(Icons.color_lens_outlined),
                            onPressed: () async {
                              if (!isLoaded) return;
                              final Color? color = await Navigator.of(context)
                                  .pushNamed(ColorPickerView.routeName,
                                      arguments: {
                                    'title': user!.shortTitle,
                                    'color': user.color,
                                  });
                              if (color != null) {
                                await ApiService.user
                                    .put(
                                        firstname: user.firstname,
                                        lastname: user.lastname,
                                        status: user.status,
                                        color: color)
                                    .whenComplete(() => setState(() {}))
                                    .catchError((Object error) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error loading data!'),
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: LocalSplitter.withShimmer(
                        context: context,
                        isLoading: !isLoaded,
                        child: Text(
                          user?.title ?? AppLocalizations.of(context)!.loading,
                          style: TextStyle(
                              color: user?.color != null
                                  ? user!.color.passive
                                  : null),
                        )),
                    background: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      color: user?.color ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  pinned: true,
                  backgroundColor:
                      user?.color ?? Theme.of(context).primaryColor,
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  sliver: SliverToBoxAdapter(
                    child: LocalSplitter.withShimmer(
                        context: context,
                        isLoading: !isLoaded,
                        child: OutlinedButton(
                          child: Text(AppLocalizations.of(context)!.edit),
                          onPressed: () async {
                            if (!isLoaded) return;
                            await Navigator.of(context).pushNamed(
                                EditProfileView.routeName,
                                arguments: {
                                  'user': user,
                                }).whenComplete(() => setState(() {}));
                          },
                        )),
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  sliver: SliverToBoxAdapter(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await Navigator.of(context)
                                .pushNamed(ListUsersView.routeName, arguments: {
                              'title':
                                  AppLocalizations.of(context)!.subscribers,
                              'callback': ApiService.user.subscribers,
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 60,
                            child: LocalSplitter.withShimmer(
                              isLoading: !isLoaded,
                              context: context,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        user?.subscribersCount.toString() ??
                                            '0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.subscribers,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
                            await Navigator.of(context)
                                .pushNamed(ListUsersView.routeName, arguments: {
                              'title':
                                  AppLocalizations.of(context)!.subscriptions,
                              'callback': ApiService.user.subscriptions,
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 60,
                            child: LocalSplitter.withShimmer(
                              isLoading: !isLoaded,
                              context: context,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        user?.subscriptionsCount.toString() ??
                                            '0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.subscriptions,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Icon(
                                        Icons.add_alert,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .color,
                                        semanticLabel:
                                            AppLocalizations.of(context)!
                                                .remind,
                                        size: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .fontSize! -
                                            8,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.remind,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
            );
          }),
    );
  }
}
