import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/fadeanimation.dart';
import 'package:notify/components/textbutton.dart';
import 'package:notify/components/textformfield.dart';

class AuthPageSignUp extends StatelessWidget {
  const AuthPageSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          FadeAnimation(
            delay: 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MaterialButton(
                  child: Text(
                    "Have account",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, '/AuthPageSignIn'),
                )
              ],
            ),
          ),
          FadeAnimation(
            delay: 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign up",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your first name',
              labelText: 'First name',
            ),
          ),
          const SizedBox(height: 10),
          const FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your last name',
              labelText: 'Last name',
            ),
          ),
          const SizedBox(height: 10),
          const FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your login',
              labelText: 'Login',
            ),
          ),
          const SizedBox(height: 10),
          const FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your password',
              labelText: 'Password',
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: FadeAnimation(
              delay: 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child:
                          NotifyTextButton(text: 'Continue', onPressed: () {})),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
