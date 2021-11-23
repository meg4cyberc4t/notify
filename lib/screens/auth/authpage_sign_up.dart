import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megasdkdart/megasdkdart.dart';
import 'package:notify/components/methods/is_digit.dart';
import 'package:notify/components/widgets/fade_animation.dart';
import 'package:notify/components/widgets/text_button.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/components/BLoC/text_field_validator_bloc.dart';

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
        clipBehavior: Clip.antiAliasWithSaveLayer,
        scrollDirection: Axis.vertical,
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
              child: BlocProvider(
                create: (context) => TextFieldValidatorBloc(null),
                child: BlocBuilder<TextFieldValidatorBloc, String?>(
                  builder: (BuildContext context, String? errorTextFromBLoC) {
                    return NotifyTextField(
                      hintText: 'Your first name',
                      labelText: 'First name',
                      errorText: errorTextFromBLoC,
                      onChanged: (value) async {
                        value = value.toLowerCase();
                        if (value.isEmpty) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventEmpty());
                        } else if (haveDigit(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNeedOnlyLetters());
                        } else if (["login", "password"].contains(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventAreYouKidding());
                        } else {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventCancel());
                        }
                      },
                      controller: _controllerFirstname,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: BlocProvider(
                create: (context) => TextFieldValidatorBloc(null),
                child: BlocBuilder<TextFieldValidatorBloc, String?>(
                  builder: (BuildContext context, String? errorTextFromBLoC) {
                    return NotifyTextField(
                      hintText: 'Your last name',
                      labelText: 'Last name',
                      errorText: errorTextFromBLoC,
                      onChanged: (value) async {
                        value = value.toLowerCase();
                        if (value.isEmpty) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventEmpty());
                        } else if (haveDigit(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNeedOnlyLetters());
                        } else if (["login", "password"].contains(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventAreYouKidding());
                        } else {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventCancel());
                        }
                      },
                      controller: _controllerLastname,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: BlocProvider(
                create: (context) => TextFieldValidatorBloc(null),
                child: BlocBuilder<TextFieldValidatorBloc, String?>(
                  builder: (BuildContext context, String? errorTextFromBLoC) {
                    return NotifyTextField(
                      hintText: 'Your login',
                      labelText: 'Login',
                      errorText: errorTextFromBLoC,
                      onChanged: (value) async {
                        value = value.toLowerCase();
                        if (value.length < 3) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNoLength());
                        } else if (value.isEmpty) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventEmpty());
                        } else if (int.tryParse(value) != null) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNeedLetters());
                        } else if (["login", "password"].contains(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventAreYouKidding());
                        } else if (await widget.sdk.auth
                                .isCorrectLoginWithStatusCode(value) ==
                            422) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventAlreadyUsed());
                        } else {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventCancel());
                        }
                      },
                      controller: _controllerLogin,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
              delay: 0.95,
              child: BlocProvider(
                create: (context) => TextFieldValidatorBloc(null),
                child: BlocBuilder<TextFieldValidatorBloc, String?>(
                  builder: (BuildContext context, String? errorTextFromBLoC) {
                    return NotifyTextField(
                      hintText: 'Your password',
                      labelText: 'Password',
                      errorText: errorTextFromBLoC,
                      onChanged: (value) async {
                        value = value.toLowerCase();
                        if (value.length < 5) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNoLength());
                        } else if (value.isEmpty) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventEmpty());
                        } else if (int.tryParse(value) != null) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventNeedLetters());
                        } else if (["login", "password"].contains(value)) {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventAreYouKidding());
                        } else {
                          BlocProvider.of<TextFieldValidatorBloc>(context)
                              .add(TextFieldValidatorEventCancel());
                        }
                      },
                      controller: _controllerPassword,
                    );
                  },
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
                            text: 'Continue',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      dismissDirection: DismissDirection.down,
                                      content: Text(
                                          "Check the errors in the fields!",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .button!
                                                      .color))));
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
