import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckEmailView extends StatefulWidget {
  const CheckEmailView({Key? key}) : super(key: key);

  static const routeName = '/check_email_view';

  @override
  State<CheckEmailView> createState() => _CheckEmailViewState();
}

class _CheckEmailViewState extends State<CheckEmailView> {
  late Timer timer;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) => checkEmailVerified(),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser!;
    user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 150,
              ),
              const SizedBox(height: 100),
              Text(
                '${AppLocalizations.of(context)!.checkEmailViewPart1} '
                '"${FirebaseAuth.instance.currentUser!.email}".\n'
                '${AppLocalizations.of(context)!.checkEmailViewPart2}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
