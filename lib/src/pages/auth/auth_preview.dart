import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/pages/auth/sign_up_view.dart';
import 'package:notify/src/pages/router_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';

class AuthPreview extends StatefulWidget {
  const AuthPreview({Key? key}) : super(key: key);
  static const String routeName = '/auth_preview';

  @override
  State<AuthPreview> createState() => _AuthPreviewState();
}

class _AuthPreviewState extends State<AuthPreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'auth_preview');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      restorationId: AuthPreview.routeName,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth_background_view.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.ntfManager,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.authPreview,
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final GoogleSignIn _googleSignIn =
                                    GoogleSignIn();
                                GoogleSignInAccount? googleSignInAccount =
                                    await _googleSignIn.signIn();
                                if (googleSignInAccount == null) {
                                  return;
                                }
                                GoogleSignInAuthentication
                                    googleSignInAuthentication =
                                    await googleSignInAccount.authentication;
                                AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken:
                                      googleSignInAuthentication.accessToken,
                                  idToken: googleSignInAuthentication.idToken,
                                );
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                NotifyUserDetailed user =
                                    await ApiService.user.get();
                                debugPrint(user.title +
                                    ' loggined with ApiService in Notify');
                                await Navigator.of(context, rootNavigator: true)
                                    .pushReplacementNamed(RouterView.routeName);
                              } on ApiServiceException {
                                await Navigator.of(context)
                                    .pushNamed(SignUpView.routeName);
                              } on PlatformException catch (e) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.getStarted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
