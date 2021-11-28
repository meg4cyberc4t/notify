import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/outlined_button.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).backgroundColor,
        title:
            Text('meg4cyberc4t', style: Theme.of(context).textTheme.headline6),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Hero(
                      tag: "avatar",
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Center(
                          child: Text(
                            "IM",
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 1,
                            semanticsLabel: 'Avatar text',
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Igor',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          'Molchanov',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: NotifyOutlinedButton(
                        widget: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Add',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NotifyOutlinedButton(
                        widget: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.qrcode,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'QR code',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.grey[300]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: Text('Collegues:',
                    style: Theme.of(context).textTheme.headline6),
              ),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 10),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      title: 'Sofia',
                      iconTitle: 'SK',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      title: 'Alexander',
                      iconTitle: 'AS',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      title: 'Alisa',
                      iconTitle: 'AM',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      title: 'Marat',
                      iconTitle: 'MG',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      title: 'Melania',
                      iconTitle: 'MM',
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey[300]),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              //   child: Text('Information:',
              //       style: Theme.of(context).textTheme.headline6),
              // ),
              // SizedBox(
              //   height: 100,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: const [
              //       SizedBox(width: 10),
              //       UserItemCard(
              //           color: Colors.purple,
              //           title: 'Collegues',
              //           iconTitle: '42'),
              //       UserItemCard(
              //           color: Colors.deepPurpleAccent,
              //           title: 'Created',
              //           subtitle: 'ntf',
              //           iconTitle: '24'),
              //       UserItemCard(
              //           color: Colors.deepPurpleAccent,
              //           title: 'Created',
              //           subtitle: 'folder',
              //           iconTitle: '28'),
              //       UserItemCard(
              //           color: Colors.blueAccent,
              //           title: 'Edited',
              //           subtitle: 'ntf',
              //           iconTitle: '12'),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserItemCard extends StatelessWidget {
  const UserItemCard({
    required this.title,
    required this.color,
    required this.iconTitle,
    Key? key,
  }) : super(key: key);
  final String title;
  final Color color;
  final String iconTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: "avatar",
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                  child: Text(
                    iconTitle,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.headline3!.fontSize! /
                                2),
                    maxLines: 1,
                    semanticsLabel: 'Avatar text',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
            Text(title, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
