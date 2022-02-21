import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notify/src/notify_api_client/api_client.dart';
import 'package:notify/src/notify_api_client/errors/exception_model.dart';
import 'package:notify/src/pages/auth/check_email_view.dart';
import 'package:notify/src/pages/auth/sign_up_view.dart';
import 'package:notify/src/pages/router_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key, this.appBarColor}) : super(key: key);

  static const routeName = '/sign_in';
  final Color? appBarColor;

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color passiveColor(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
          ? Colors.black
          : Colors.white;

  @override
  Widget build(BuildContext context) {
    Color appBarColor =
        widget.appBarColor ?? Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: appBarColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppLocalizations.of(context)!.signInTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: passiveColor(appBarColor)),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              background: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: appBarColor,
              ),
            ),
            iconTheme: IconThemeData(color: passiveColor(appBarColor)),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 8).add(
              const EdgeInsets.only(top: 4),
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
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
                        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                          final bool isVerify = await Navigator.of(context)
                              .pushNamed(CheckEmailView.routeName) as bool;
                          if (!isVerify) return;
                        }
                        await Navigator.of(context)
                            .pushReplacementNamed(RouterView.routeName);
                      },
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
                        var _dname = _user.displayName!.split(' ');
                        String firstname;
                        String lastname;
                        if (_dname.length <= 1) {
                          firstname = _user.displayName!;
                          lastname = '';
                        } else {
                          firstname = _dname[0];
                          lastname = _dname[1];
                        }
                        try {
                          await ApiClient.user.post(
                            firstname: firstname,
                            lastname: lastname,
                          );
                        } on NotifyApiClientException catch (e) {
                          if (e.statusCode != 409) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(e.localTitle(context))),
                            );
                            debugPrint(e.message);
                            return;
                          }
                        }
                        await Navigator.of(context)
                            .pushReplacementNamed(RouterView.routeName);
                      },
                      child: Image.asset(
                        'assets/images/google_logo.png',
                        height: 32,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async =>
                          await Navigator.of(context).pushNamed(
                        SignUpView.routeName,
                      ),
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
