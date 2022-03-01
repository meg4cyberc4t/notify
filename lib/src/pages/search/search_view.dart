import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  static const String routeName = '/search_view';
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Search view')),
    );
  }
}
