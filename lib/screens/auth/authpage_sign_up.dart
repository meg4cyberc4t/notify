import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/components/BLoC/avatar_props_validator_bloc.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/components/widgets/direct_button.dart';
import 'package:notify/components/widgets/snack_bar.dart';
import 'package:notify/components/widgets/text_field.dart';
import 'package:notify/screens/colorpickerpage.dart';
import 'package:notify/services/firebase_service.dart';

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
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  void dispose() {
    _controllerFirstname.dispose();
    _controllerLastname.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: BlocProvider(
          create: (context) => AvatarPropsValidatorBloc(
            AvatarProps(color: color, title: "LA"),
          ),
          child: Builder(builder: (context) {
            String getAvatarTitle() {
              String letter1 = "";
              try {
                letter1 = _controllerFirstname.text[0];
              } catch (_) {}
              String letter2 = "";
              try {
                letter2 = _controllerLastname.text[0];
              } catch (_) {}
              return (letter1 + letter2).toUpperCase();
            }

            void updateAvatarTitle() =>
                BlocProvider.of<AvatarPropsValidatorBloc>(context)
                    .add(AvatarProps(title: getAvatarTitle()));

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      child: Text(
                        "Have account",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/AuthPageSignIn'),
                    )
                  ],
                ),
                Row(
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
                const SizedBox(height: 10),
                BlocBuilder<AvatarPropsValidatorBloc, AvatarProps>(
                  builder: (context, AvatarProps props) => Avatar(
                    title: props.title!,
                    color: props.color!,
                    size: AvatarSize.max,
                    onTap: () async {
                      final Color? inputColor = await Navigator.push(
                          context,
                          Platform.isAndroid
                              ? MaterialPageRoute(
                                  builder: (context) => ColorPickerPage(
                                        title: props.title!,
                                        initialValue: props.color,
                                      ))
                              : CupertinoPageRoute(
                                  builder: (context) => ColorPickerPage(
                                        title: props.title!,
                                        initialValue: props.color,
                                      )));
                      if (inputColor != null) {
                        BlocProvider.of<AvatarPropsValidatorBloc>(context)
                            .add(AvatarProps(color: inputColor));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                NotifyTextField(
                  hintText: 'Your first name',
                  labelText: 'First name',
                  controller: _controllerFirstname,
                  onChanged: (value) => updateAvatarTitle(),
                ),
                const SizedBox(height: 10),
                NotifyTextField(
                  hintText: 'Your last name',
                  labelText: 'Last name',
                  controller: _controllerLastname,
                  onChanged: (value) => updateAvatarTitle(),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: NotifyDirectButton.text(
                            text: 'Continue',
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
                                      color: color);
                              if (error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    notifySnackBar(error, context));
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/MainPage');
                              }
                            })),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    ));
  }
}
