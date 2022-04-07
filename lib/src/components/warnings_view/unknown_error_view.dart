import 'package:flutter/material.dart';
import 'package:notify/src/pages/settings/about_view.dart';
import 'package:url_launcher/url_launcher.dart';

class UnknownErrorView extends StatelessWidget {
  const UnknownErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: Theme.of(context).textTheme.headline4!.fontSize,
            ),
            const SizedBox(height: 8),
            Text(
              'Неопознанная ошибка',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'К сожалению, не все баги удаётся устранить',
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () async => launch(AboutView.newIssueUrl),
              child: const Text(
                'Сообщить разработчикам',
                textAlign: TextAlign.center,
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
