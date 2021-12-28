import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/authpage1.png"),
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
                  "Let's create a space for your notification",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: NotifyDirectButton(
                      title: 'Get started',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/AuthPageSignUp'),
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
