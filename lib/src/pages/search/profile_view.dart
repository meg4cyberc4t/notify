import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);
  static const routeName = 'search_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SearchView')),
    );
  }
}
