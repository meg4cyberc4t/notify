import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/snack_bar.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

class AuthPageSignIn extends StatefulWidget {
  const AuthPageSignIn({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(),
          Text(
            'Sign in',
            style: Theme.of(context).textTheme.headline3,
          ),
          Column(
            children: [
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
            children: [
              NotifyDirectButton(
                  title: 'Continue',
                  onPressed: () async {
                    String? error =
                        await context.read<FirebaseService>().signIn(
                              email: _controllerEmail.text.trim(),
                              password: _controllerPassword.text.trim(),
                            );
                    if (error != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(notifySnackBar(error, context));
                    } else {
                      Navigator.pushReplacementNamed(context, '/MainPage');
                    }
                  }),
              const SizedBox(height: 10),
              NotifyDirectButton(
                title: 'Create account',
                style: NotifyDirectButtonStyle.slience,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/AuthPageSignUp'),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
