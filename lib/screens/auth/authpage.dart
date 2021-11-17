import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/fadeanimation.dart';
import 'package:notify/components/textbutton.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        FadeAnimation(
          delay: 0.7,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/authpage1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(
                delay: 0.8,
                child: Text(
                  " ntf manager",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FadeAnimation(
                  delay: 0.9,
                  child: Text(
                    "Let’s create a space for your notification",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FadeAnimation(
                        delay: 1.0,
                        child: NotifyTextButton(
                          text: 'Get started',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/AuthPage2'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
