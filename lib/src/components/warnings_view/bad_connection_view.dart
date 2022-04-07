import 'package:flutter/material.dart';

class BadConnectionView extends StatelessWidget {
  const BadConnectionView({
    Key? key,
    final this.callback,
  }) : super(key: key);

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              Icons.cell_tower_outlined,
              size: Theme.of(context).textTheme.headline4!.fontSize,
            ),
            const SizedBox(height: 8),
            Text(
              'Плохое соединение',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Проверьте настройки сети или обновите экран',
              textAlign: TextAlign.center,
            ),
            if (callback != null)
              TextButton(
                onPressed: callback,
                child: const Text(
                  'Повторить',
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
