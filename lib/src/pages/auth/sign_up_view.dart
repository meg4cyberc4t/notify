// ignore_for_file: prefer_single_quotes

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/notify_api_client/api_client.dart';
import 'package:notify/src/notify_api_client/errors/exception_model.dart';
import 'package:notify/src/pages/auth/check_email_view.dart';
import 'package:notify/src/pages/color_picker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/pages/homepage.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String title = '';
  late Color colorValue;

  String get shortTitle {
    String localTitle = '';
    if (_firstnameController.text.isNotEmpty) {
      localTitle += _firstnameController.text[0];
    }
    if (_lastnameController.text.isNotEmpty) {
      localTitle += _lastnameController.text[0];
    }
    return localTitle.trim();
  }

  String get longTitle {
    String localTitle = '';
    if (_firstnameController.text.isNotEmpty) {
      localTitle += _firstnameController.text;
    }
    localTitle += ' ';
    if (_lastnameController.text.isNotEmpty) {
      localTitle += _lastnameController.text;
    }
    return localTitle.trim();
  }

  void updateTitleIfUpdate() {
    setState(() {
      title =
          (_firstnameController.text + ' ' + _lastnameController.text).trim();
    });
  }

  @override
  void initState() {
    colorValue = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _firstnameController.addListener(updateTitleIfUpdate);
    _lastnameController.addListener(updateTitleIfUpdate);
    super.initState();
  }

  Color passiveColor(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
          ? Colors.black
          : Colors.white;

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty) {
      title = AppLocalizations.of(context)!.signUpTitle;
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorValue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: passiveColor(colorValue)),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              background: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: colorValue,
              ),
            ),
            iconTheme: IconThemeData(color: passiveColor(colorValue)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final Color? newValue = await Navigator.of(context)
                      .pushNamed(ColorPickerView.routeName, arguments: {
                    'title': shortTitle.isNotEmpty ? shortTitle : 'SU',
                    'color': colorValue,
                  });
                  if (newValue == null) {
                    return;
                  }
                  setState(() => colorValue = newValue);
                },
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _firstnameController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.firstNameTitle,
                  counterText: '',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _lastnameController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.lastNameTitle,
                  counterText: '',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.emailTitle,
                  hintText: AppLocalizations.of(context)!.emailHint,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordTitle,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(e.message!),
                                ),
                              );
                              return;
                            }
                            FirebaseAuth.instance.currentUser!
                                .updateDisplayName(
                                    _firstnameController.text.trim() +
                                        " " +
                                        _lastnameController.text.trim());
                            print(
                                FirebaseAuth.instance.currentUser!.displayName);
                            if (!FirebaseAuth
                                .instance.currentUser!.emailVerified) {
                              final bool isVerify = await Navigator.of(context)
                                  .pushNamed(CheckEmailView.routeName) as bool;
                              if (!isVerify) return;
                            }

                            try {
                              await ApiClient.user.post(
                                firstname: _firstnameController.text.trim(),
                                lastname: _lastnameController.text.trim(),
                                color: colorValue,
                              );
                            } on NotifyApiClientException catch (e) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(e.localTitle(context))),
                              );
                              debugPrint(e.message);
                              return;
                            }
                            await Navigator.of(context)
                                .pushReplacementNamed(HomePage.routeName);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.continueButton),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text(AppLocalizations.of(context)!.backButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
