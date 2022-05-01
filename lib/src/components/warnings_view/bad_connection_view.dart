import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BadConnectionView extends StatelessWidget {
  const BadConnectionView({
    Key? key,
    final this.callback,
  }) : super(key: key);

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Icon(
                Icons.cell_tower_outlined,
                size: Theme.of(context).textTheme.headline5!.fontSize,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.badConnection,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.checkYourConnection,
                textAlign: TextAlign.center,
              ),
              if (callback != null)
                TextButton(
                  onPressed: callback,
                  child: Text(
                    AppLocalizations.of(context)!.repeat,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
