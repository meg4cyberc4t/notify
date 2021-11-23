import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/fade_animation.dart';
import 'package:notify/components/widgets/text_button.dart';

class AuthPage2 extends StatelessWidget {
  const AuthPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        FadeAnimation(
          delay: 0.8,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/authpage2.png"),
                fit: BoxFit.cover,
              ),
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
              FadeAnimation(
                delay: 0.9,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Calendar, notification, management",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: FadeAnimation(
                  delay: 1.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: NotifyTextButton(
                              text: 'Sign up',
                              onPressed: () => Navigator.pushNamed(
                                  context, '/AuthPageSignUp'))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: NotifyTextButton(
                              text: 'Sign in',
                              onPressed: () => Navigator.pushNamed(
                                  context, '/AuthPageSignIn'))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
