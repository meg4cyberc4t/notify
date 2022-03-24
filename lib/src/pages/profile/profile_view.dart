import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/components/local_splitter.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:notify/src/pages/additional/list_notifications_view.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/profile/edit_profile_view.dart';
import 'package:notify/src/pages/settings/settings_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    this.id,
    this.preTitle,
    Key? key,
  }) : super(key: key);
  static const routeName = 'profile_view';
  final String? id;
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
    super.build(context);
    return Scaffold(
      restorationId: 'profile_view',
      key: _scaffoldKey,
      body: LocalFutureBuilder.withLoading<NotifyUserDetailed>(
        future: (widget.id == null)
            ? (() async => Provider.of<UserState>(context).user)()
            : ApiService.users.get(widget.id!),
        onError: (BuildContext context, Object err) =>
            Center(child: Text(err.toString())),
        onLoading:
            (BuildContext context, NotifyUserDetailed? user, bool isLoaded) =>
                CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                  color:
                      (user?.color ?? Theme.of(context).primaryColor).passive),
              expandedHeight: 300,
              actions: [
                if (user?.itsMe ?? false)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SettingsView.routeName);
                    },
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: LocalSplitter.withShimmer(
                    context: context,
                    isLoading: !isLoaded,
                    child: Text(
                      user?.title ?? AppLocalizations.of(context)!.loading,
                      style: TextStyle(
                          color:
                              user?.color != null ? user!.color.passive : null),
                    )),
                background: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  color: user?.color ?? Theme.of(context).primaryColor,
                ),
              ),
              leading: !(user?.itsMe ?? false)
                  ? null
                  : Navigator.of(context).canPop()
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
                                try {
                                  Provider.of<UserState>(context, listen: false)
                                      .edit(color: color);
                                } on Exception catch (error) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(error.toString())),
                                  );
                                }
                              }
                            },
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
                          return TextButton(
                            child: Text(AppLocalizations.of(context)!.loading),
                            onPressed: null,
                          );
                        } else if (user!.follow) {
                          return OutlinedButton(
                            child: Text(AppLocalizations.of(context)!.unfollow),
                            onPressed: () async {
                              if (!isLoaded) return;
                              await ApiService.user.changeSubscription(user.id);
                              setState(() {});
                            },
                          );
                        } else if (user.itsMe) {
                          return OutlinedButton(
                            child: Text(AppLocalizations.of(context)!.edit),
                            onPressed: () async {
                              if (!isLoaded) return;
                              await Navigator.of(context).pushNamed(
                                  EditProfileView.routeName,
                                  arguments: {'user': user});
                            },
                          );
                        }
                        return ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.follow),
                          onPressed: () async {
                            if (!isLoaded) return;
                            await ApiService.user.changeSubscription(user.id);
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
                        if (user == null) return;
                        callback() => ApiService.users.subscribers(user.id);
                        await Navigator.of(context)
                            .pushNamed(ListUsersView.routeName, arguments: {
                          'title': AppLocalizations.of(context)!.subscribers,
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
                                AppLocalizations.of(context)!.subscribers,
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
                        if (user == null) return;
                        callback() => ApiService.users.subscriptions(user.id);
                        await Navigator.of(context)
                            .pushNamed(ListUsersView.routeName, arguments: {
                          'title': AppLocalizations.of(context)!.subscriptions,
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
                                AppLocalizations.of(context)!.subscriptions,
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
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (user == null) return;
                        Navigator.of(context).pushNamed(
                            ListNotificationsView.routeName,
                            arguments: {
                              'title': AppLocalizations.of(context)!
                                  .generalReminders,
                              'callback': () =>
                                  ApiService.users.notifications(user.id)
                            });
                      },
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
                                    user?.numberOfNotifications.toString() ??
                                        '0',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              Text(
                                'Напоминания',
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.center,
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
