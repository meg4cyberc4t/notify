import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/fade_animation.dart';
import 'package:notify/components/widgets/text_button.dart';

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
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(
                delay: 0.8,
                child: Text(
                  "ntf manager",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FadeAnimation(
                  delay: 0.9,
                  child: Text(
                    "Let’s create a space for your notification",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
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
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    ));
  }
}
