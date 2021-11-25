import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megasdkdart/megasdkdart.dart';
import 'package:notify/components/widgets/fade_animation.dart';
import 'package:notify/components/widgets/text_button.dart';
import 'package:notify/components/widgets/text_field.dart';

class AuthPageSignIn extends StatefulWidget {
  const AuthPageSignIn({Key? key, required this.sdk}) : super(key: key);
  final MegaSDK sdk;

  @override
  State<AuthPageSignIn> createState() => _AuthPageSignInState();
}

class _AuthPageSignInState extends State<AuthPageSignIn> {
  final TextEditingController _controllerLogin = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  @override
  void dispose() {
    _controllerLogin.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

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
          const SizedBox(height: 50),
          FadeAnimation(
            delay: 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MaterialButton(
                  child: Text(
                    "Create account",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, '/AuthPageSignUp'),
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
                  "Sign in",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your login',
              labelText: 'Login',
              controller: _controllerLogin,
            ),
          ),
          const SizedBox(height: 10),
          FadeAnimation(
            delay: 0.95,
            child: NotifyTextField(
              hintText: 'Your password',
              labelText: 'Password',
              obscureText: true,
              controller: _controllerPassword,
            ),
          ),
          const SizedBox(height: 10),
          FadeAnimation(
            delay: 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: NotifyTextButton(
                        text: 'Continue',
                        onPressed: () async {
                          try {
                            var data = await widget.sdk.auth.signIn(
                              _controllerLogin.text.trim(),
                              _controllerPassword.text.trim(),
                            );
                            Box box = Hive.box('Fenestra');
                            box.put('auth_token', data['auth_token']);
                            box.put('refresh_token', data['refresh_token']);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/MainPage', (Route<dynamic> route) => false);
                          } on AssertionError catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                dismissDirection: DismissDirection.down,
                                content: Text(e.message.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .button!
                                                .color))));
                          }
                        })),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}
