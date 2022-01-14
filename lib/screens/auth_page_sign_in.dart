// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart' as fauth
    show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_snack_bar.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/services/firebase_service.dart';

class AuthPageSignIn extends StatefulWidget {
  const AuthPageSignIn({final Key? key}) : super(key: key);

  @override
  State<AuthPageSignIn> createState() => _AuthPageSignInState();
}

class _AuthPageSignInState extends State<AuthPageSignIn> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(),
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headline3,
              ),
              Column(
                children: <Widget>[
                  NotifyTextField(
                    hintText: 'Your email',
                    labelText: 'Email',
                    controller: _controllerEmail,
                  ),
                  const SizedBox(height: 10),
                  NotifyTextField(
                    hintText: 'Your password',
                    labelText: 'Password',
                    obscureText: true,
                    controller: _controllerPassword,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  NotifyDirectButton(
                    title: 'Continue',
                    onPressed: () async {
                      try {
                        await FirebaseService.of(context).signIn(
                          email: _controllerEmail.text.trim(),
                          password: _controllerPassword.text.trim(),
                        );
                        if (mounted) {
                          await Navigator.of(context)
                              .pushReplacementNamed('/MainPage');
                        }
                      } on fauth.FirebaseAuthException catch (err) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          notifySnackBar(err.message!, context),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  NotifyDirectButton(
                    title: 'Create account',
                    style: NotifyDirectButtonStyle.slience,
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/AuthPageSignUp',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
