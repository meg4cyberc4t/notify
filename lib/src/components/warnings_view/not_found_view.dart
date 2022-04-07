import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: Theme.of(context).textTheme.headline4!.fontSize,
            ),
            const SizedBox(height: 8),
            Text(
              'Не найдено',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Попробуйте поискать что-нибудь другое',
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
