import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notify/src/pages/color_picker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.continueButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final GoogleSignIn _googleSignIn = GoogleSignIn();
                        GoogleSignInAccount? googleSignInAccount =
                            await _googleSignIn.signIn();
                        if (googleSignInAccount == null) {
                          print('Выход');
                          return;
                        }
                        GoogleSignInAuthentication googleSignInAuthentication =
                            await googleSignInAccount.authentication;
                        AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: googleSignInAuthentication.accessToken,
                          idToken: googleSignInAuthentication.idToken,
                        );
                        UserCredential authResult =
                            await _auth.signInWithCredential(credential);
                        var _user = authResult.user!;
                        assert(_user.isAnonymous);
                        User currentUser = _auth.currentUser!;
                        assert(_user.uid == currentUser.uid);
                        print("User Name: ${_user.displayName}");

                        print(_user.emailVerified);
                        print("User Email ${_user.email}");
                        // TODO: Redirect on home page
                      },
                      child: Image.asset(
                        'assets/images/google_logo.png',
                        height: 32,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Image.asset(
                        'assets/images/microsoft_logo.png',
                        height: 32,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.email_outlined,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
