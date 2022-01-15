// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as fauth
    show FirebaseAuthException;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_snack_bar.dart';
import 'package:notify/components/widgets/notify_text_field.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/screens/color_picker_page.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/static_methods/custom_route.dart';
import 'package:redux/redux.dart';

class AuthPageSignUp extends StatefulWidget {
  const AuthPageSignUp({final Key? key}) : super(key: key);

  @override
  State<AuthPageSignUp> createState() => _AuthPageSignUpState();
}

class _AuthPageSignUpState extends State<AuthPageSignUp> {
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerFirstname.dispose();
    _controllerLastname.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  String getAvatarTitle() {
    String title = '';
    if (_controllerFirstname.text.isNotEmpty) {
      title += _controllerFirstname.text[0];
    }
    if (_controllerLastname.text.isNotEmpty) {
      title += _controllerLastname.text[0];
    }
    return title.toUpperCase();
  }

  Color colorReducer(final Color state, final dynamic newState) {
    if (newState is Color) {
      return newState;
    }
    return state;
  }

  String titleReducer(final String state, final dynamic newState) {
    if (newState is String) {
      return newState;
    }
    return state;
  }

  late Store<Color> colorStore;
  late Store<String> titleStore;
  @override
  void initState() {
    super.initState();
    colorStore = Store<Color>(
      colorReducer,
      initialState: Colors.primaries[Random().nextInt(Colors.primaries.length)],
    );
    titleStore = Store<String>(
      titleReducer,
      initialState: 'LA',
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StoreProvider<Color>(
                store: colorStore,
                child: StoreProvider<String>(
                  store: titleStore,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(),
                      Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      StoreConnector<String, String>(
                        converter: (final Store<String> store) => store.state,
                        builder: (
                          final BuildContext context,
                          final String title,
                        ) =>
                            StoreConnector<Color, Color>(
                          converter: (final Store<Color> store) => store.state,
                          builder:
                              (final BuildContext context, final Color color) =>
                                  NotifyAvatar(
                            title: title,
                            color: color,
                            size: AvatarSize.max,
                            onTap: () => Navigator.push(
                              context,
                              customRoute(
                                ColorPickerPage(
                                  title: title,
                                  initialValue: color,
                                ),
                              ),
                            ).then((final dynamic value) {
                              if (value != null) {
                                colorStore.dispatch(value);
                              }
                            }),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          NotifyTextField(
                            hintText: 'Your first name',
                            labelText: 'First name',
                            controller: _controllerFirstname,
                            onChanged: (final String value) =>
                                titleStore.dispatch(getAvatarTitle()),
                          ),
                          const SizedBox(height: 10),
                          NotifyTextField(
                            hintText: 'Your last name',
                            labelText: 'Last name',
                            controller: _controllerLastname,
                            onChanged: (final String value) =>
                                titleStore.dispatch(getAvatarTitle()),
                          ),
                          const SizedBox(height: 10),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                notifySnackBar('Downloading...', context),
                              );
                              try {
                                await FirebaseService.signUp(
                                  email: _controllerEmail.text.trim(),
                                  password: _controllerPassword.text.trim(),
                                  firstName: _controllerFirstname.text.trim(),
                                  lastName: _controllerLastname.text.trim(),
                                  color: colorStore.state,
                                );
                                if (mounted) {
                                  await Navigator.of(context)
                                      .pushReplacementNamed(
                                    '/MainPage',
                                  );
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
                            title: 'Already have',
                            style: NotifyDirectButtonStyle.slience,
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed(
                              '/AuthPageSignIn',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Store<Color>>('colorStore', colorStore))
      ..add(DiagnosticsProperty<Store<String>>('titleStore', titleStore));
  }
}
