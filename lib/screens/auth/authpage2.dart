import 'package:flutter/material.dart';
import 'package:notify/components/widgets/direct_button.dart';

class AuthPage2 extends StatelessWidget {
  const AuthPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/authpage2.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "Calendar, notification, management",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: NotifyDirectButton.text(
                          text: 'Sign up',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/AuthPageSignUp'))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: NotifyDirectButton.text(
                          text: 'Sign in',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/AuthPageSignIn'))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    ));
  }
}
