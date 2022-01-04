// ignore_for_file: public_member_api_docs, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/authpage.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Let's create a space for your notification",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: NotifyDirectButton(
                      title: 'Get started',
                      style: NotifyDirectButtonStyle.outlined,
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/AuthPageSignIn',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
