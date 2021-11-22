import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megasdkdart/megasdkdart.dart';
import 'package:notify/components/methods/inputvalidators.dart';
import 'package:notify/components/widgets/fadeanimation.dart';
import 'package:notify/components/widgets/textbutton.dart';
import 'package:notify/components/widgets/textformfield.dart';

class AuthPageSignUp extends StatefulWidget {
  const AuthPageSignUp({
    Key? key,
    required this.sdk,
  }) : super(key: key);
  final MegaSDK sdk;

  @override
  State<AuthPageSignUp> createState() => _AuthPageSignUpState();
}

class _AuthPageSignUpState extends State<AuthPageSignUp> {
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerLogin = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerFirstname.dispose();
    _controllerLastname.dispose();
    _controllerLogin.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
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
            FadeAnimation(
              delay: 0.95,
              child: NotifyTextField(
                hintText: 'Your first name',
                labelText: 'First name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: userfieldValidator,
                controller: _controllerFirstname,
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: NotifyTextField(
                hintText: 'Your last name',
                labelText: 'Last name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: userfieldValidator,
                controller: _controllerLastname,
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: _LocalLoginTextWidget(
                  controllerLogin: _controllerLogin, widget: widget),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: NotifyTextField(
                hintText: 'Your password',
                labelText: 'Password',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: passwordValidator,
                controller: _controllerPassword,
                obscureText: true,
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
                            text: 'Continue',
                            onPressed: () {
                              if ((userfieldValidator(
                                          _controllerFirstname.text) ==
                                      null) &&
                                  (userfieldValidator(
                                          _controllerLastname.text) ==
                                      null) &&
                                  (loginValidator(_controllerLogin.text) ==
                                      null) &&
                                  (passwordValidator(
                                          _controllerPassword.text) ==
                                      null)) {}
                            })),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _LocalLoginTextWidget extends StatefulWidget {
  const _LocalLoginTextWidget({
    Key? key,
    required TextEditingController controllerLogin,
    required this.widget,
  })  : _controllerLogin = controllerLogin,
        super(key: key);

  final TextEditingController _controllerLogin;
  final AuthPageSignUp widget;

  @override
  State<_LocalLoginTextWidget> createState() => _LocalLoginTextWidgetState();
}

class _LocalLoginTextWidgetState extends State<_LocalLoginTextWidget> {
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return NotifyTextField(
      hintText: 'Your login',
      labelText: 'Login',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        var validator = loginValidator(value);
        if (validator != null) {
          return validator;
        }
        if (errorText.isNotEmpty) {
          return errorText;
        }
        return null;
      },
      controller: widget._controllerLogin,
      onChanged: (value) async {
        (value);
        if (await widget.widget.sdk.auth.isCorrectLoginWithStatusCode(value) ==
            422) {
          setState(() => errorText = "Login already exists");
        } else if (errorText != "") {
          setState(() => errorText = "");
        }
      },
    );
  }
}
