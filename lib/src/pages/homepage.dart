import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notify/src/notify_api_client/api_client.dart';
import 'package:notify/src/notify_api_client/models/notify_user_detailed.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home_page';

  @override
  Widget build(BuildContext context) {
    //#! This is a dummy screen, for authorization verification
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: ApiClient.user.get(),
            builder: (context, AsyncSnapshot<NotifyUserDetailed> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        '//#! This is a dummy screen, for authorization verification!'),
                    Text(snapshot.data!.toJson().toString()),
                    Text(
                      FirebaseAuth.instance.currentUser.toString(),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await Navigator.of(context)
                            .pushReplacementNamed(AuthPreview.routeName);
                      },
                      child: const Icon(Icons.logout),
                    ),
                    TextButton(
                        onPressed: () async {
                          final token = await FirebaseAuth.instance.currentUser!
                              .getIdToken();
                          debugPrint(token.substring(0, 1000));
                          debugPrint(token.substring(1000));
                          await Clipboard.setData(ClipboardData(text: token));
                        },
                        child: const Text('Copy token'))
                  ],
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
