import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megasdkdart/megasdkdart.dart';
import 'package:notify/components/widgets/outlined_text_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key, required this.sdk}) : super(key: key);
  final MegaSDK sdk;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.sync(() async {
            Box box = Hive.box('Fenestra');
            String refreshToken = await box.get('refresh_token') ?? '';
            var data = await sdk.auth.reloadToken(refreshToken);
            await box.put('refresh_token', data['refresh_token']);
            return data;
          }),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return FutureBuilder(
                  future: sdk.users.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text((snapshot.data as Map).toString()),
                          const SizedBox(height: 10),
                          NotifyOutlinedTextButton(
                              text: 'Log out',
                              onPressed: () async {
                                Box box = Hive.box('Fenestra');
                                await box.delete('refresh_token');
                                Navigator.pushNamed(context, '/AuthPage');
                              }),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
