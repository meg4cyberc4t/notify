import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/snack_bar.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class AuthPageSignUp extends StatefulWidget {
  const AuthPageSignUp({Key? key}) : super(key: key);

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
    String title = "";
    if (_controllerFirstname.text.isNotEmpty) {
      title += _controllerFirstname.text[0];
    }
    if (_controllerLastname.text.isNotEmpty) {
      title += _controllerLastname.text[0];
    }
    return title.toUpperCase();
  }

  Color colorReducer(Color state, dynamic newState) {
    if (newState is Color) {
      return newState;
    }
    return state;
  }

  String titleReducer(String state, dynamic newState) {
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
      initialState: "LA",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    StoreConnector<String, String>(
                        converter: (store) => store.state,
                        builder: (context, title) {
                          return StoreConnector<Color, Color>(
                            converter: (store) => store.state,
                            builder: (context, color) => Avatar(
                              title: title,
                              color: color,
                              size: AvatarSize.max,
                              onTap: () =>
                                  pushColorPickerPage(context, title, color)
                                      .then((Color? value) {
                                if (value != null) {
                                  colorStore.dispatch(value);
                                }
                              }),
                            ),
                          );
                        }),
                    Column(
                      children: [
                        NotifyTextField(
                          hintText: 'Your first name',
                          labelText: 'First name',
                          controller: _controllerFirstname,
                          onChanged: (value) =>
                              titleStore.dispatch(getAvatarTitle()),
                        ),
                        const SizedBox(height: 10),
                        NotifyTextField(
                          hintText: 'Your last name',
                          labelText: 'Last name',
                          controller: _controllerLastname,
                          onChanged: (value) =>
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
                      children: [
                        NotifyDirectButton(
                            title: 'Continue',
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  notifySnackBar('Downloading...', context));
                              String? error = await context
                                  .read<FirebaseService>()
                                  .signUp(
                                      email: _controllerEmail.text.trim(),
                                      password: _controllerPassword.text.trim(),
                                      firstName:
                                          _controllerFirstname.text.trim(),
                                      lastName: _controllerLastname.text.trim(),
                                      color: colorStore.state);
                              if (error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    notifySnackBar(error, context));
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/MainPage');
                              }
                            }),
                        const SizedBox(height: 10),
                        NotifyDirectButton(
                          title: 'Already have',
                          style: NotifyDirectButtonStyle.slience,
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/AuthPageSignIn'),
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
  }
}
