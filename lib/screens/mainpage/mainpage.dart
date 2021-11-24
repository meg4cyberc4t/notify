import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megasdkdart/megasdkdart.dart';

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
            return data['refresh_token'];
          }),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return Text(snapshot.data.toString());
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
