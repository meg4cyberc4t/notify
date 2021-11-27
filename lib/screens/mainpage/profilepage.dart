import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/outlined_text_button.dart';
import 'package:notify/components/widgets/text_button.dart';
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
                        child: NotifyTextButton(text: 'Add', onPressed: () {})),
                    const SizedBox(width: 10),
                    Expanded(
                        child: NotifyOutlinedTextButton(
                            text: 'QR code', onPressed: () {})),
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
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 10),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      firstName: 'Sofia',
                      lastName: 'Kuchmar',
                      title: 'SK',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      firstName: 'Alexander',
                      lastName: 'Stepanov',
                      title: 'AS',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      firstName: 'Alisa',
                      lastName: 'Matrosova',
                      title: 'AM',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      firstName: 'Marat',
                      lastName: 'Gevorkyan',
                      title: 'MG',
                    ),
                    UserItemCard(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      firstName: 'Melania',
                      lastName: 'Manoylovich',
                      title: 'MM',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.grey[300]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: Text('Information:',
                    style: Theme.of(context).textTheme.headline6),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: const [
                    SettingProfileItem(
                      title: 'Days straight',
                      leading: "08",
                      subcolor: Color(0xFF8474A1),
                    ),
                    SizedBox(height: 10),
                    SettingProfileItem(
                      title: 'Created ntf',
                      leading: "50",
                      subcolor: Color(0xFF6EC6CA),
                    ),
                    SizedBox(height: 10),
                    SettingProfileItem(
                      title: 'Accept ntf',
                      leading: "1K",
                      subcolor: Color(0xFFCCABD8),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserItemCard extends StatelessWidget {
  const UserItemCard({
    required this.firstName,
    required this.lastName,
    required this.color,
    required this.title,
    Key? key,
  }) : super(key: key);
  final String firstName;
  final String lastName;
  final Color color;
  final String title;

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
                    title,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
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
            Text(firstName, style: Theme.of(context).textTheme.bodyText2),
            Text(lastName, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

class SettingProfileItem extends StatelessWidget {
  const SettingProfileItem({
    Key? key,
    required this.title,
    required this.leading,
    required this.subcolor,
  }) : super(key: key);

  final String title;
  final String leading;
  final Color subcolor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: MaterialButton(
        onPressed: () {},
        color: subcolor,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  // borderRadius: const BorderRadius.only(
                  //   topRight: Radius.circular(15),
                  //   bottomRight: Radius.circular(15),
                  // ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  leading,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
