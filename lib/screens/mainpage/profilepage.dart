import 'package:flutter/material.dart';
import 'package:notify/components/widgets/progress_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: NotifyProgressIndicator(),
      ),
    );
  }
}
