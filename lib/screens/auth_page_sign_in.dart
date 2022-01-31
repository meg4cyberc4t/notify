// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_snack_bar.dart';
import 'package:notify/components/widgets/notify_text_field.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          try {
                            final GoogleSignInAccount? googleUser =
                                await GoogleSignIn().signIn();
                            final GoogleSignInAuthentication? googleAuth =
                                await googleUser?.authentication;

                            final OAuthCredential credential =
                                GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);
                            if (mounted) {
                              await Navigator.of(context)
                                  .pushReplacementNamed('/MainPage');
                            }
                          } on FirebaseAuthException catch (err) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              notifySnackBar(err.message!, context),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/google_logo.png',
                            color: Theme.of(context).colorScheme.primary,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  NotifyDirectButton(
                    title: 'Continue',
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _controllerEmail.text.trim(),
                          password: _controllerPassword.text.trim(),
                        );
                        if (mounted) {
                          await Navigator.of(context)
                              .pushReplacementNamed('/MainPage');
                        }
                      } on FirebaseAuthException catch (err) {
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
