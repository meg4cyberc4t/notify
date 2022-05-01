import 'package:flutter/material.dart';

class SearchingView extends StatelessWidget {
  const SearchingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Icon(
                Icons.search_outlined,
                size: Theme.of(context).textTheme.headline5!.fontSize,
              ),
              const SizedBox(height: 8),
              Text(
                'Поиск',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
