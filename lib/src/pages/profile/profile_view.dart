import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/components/local_future_builder.dart';
import 'package:notify/src/methods/get_passive_color.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:notify/src/pages/additional/edit_profile_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);
  static const routeName = 'profile_view';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'profile_view');
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      restorationId: 'profile_view',
      key: _scaffoldKey,
      body: LocalFutureBuilder(
        future: ApiService.user.get(),
        onProgress: (BuildContext context) =>
            const Center(child: Text('progress')),
        onError: (BuildContext context, Object err) =>
            Center(child: Text(err.toString())),
        onData: (BuildContext context, NotifyUserDetailed user) =>
            CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: getPassiveColor(user.color)),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await Navigator.of(context)
                        .pushReplacementNamed(AuthPreview.routeName);
                  },
                ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.color_lens_outlined),
                onPressed: () async {
                  final Color? color = await Navigator.of(context)
                      .pushNamed(ColorPickerView.routeName, arguments: {
                    'title': user.shortTitle,
                    'color': user.color,
                  });
                  if (color != null) {
                    await ApiService.user.put(
                        firstname: user.firstname,
                        lastname: user.lastname,
                        status: user.status,
                        color: color);
                    setState(() {});
                  }
                },
              ),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  user.title,
                  style: TextStyle(color: getPassiveColor(user.color)),
                ),
                background: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  color: user.color,
                ),
              ),
              pinned: true,
              backgroundColor: user.color,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: Text(
                  user.status,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton(
                  child: const Text('Edit'),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(EditProfileView.routeName, arguments: {
                      'user': user,
                    });
                    setState(() {});
                  },
                ),
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
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  user.subscribersCount.toString(),
                                  style: Theme.of(context).textTheme.headline4,
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
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  user.subscriptionsCount.toString(),
                                  style: Theme.of(context).textTheme.headline4,
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
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 60,
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
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
