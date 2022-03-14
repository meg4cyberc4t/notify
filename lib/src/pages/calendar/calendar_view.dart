import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);
  static const routeName = 'calendar_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('CalendarPage')),
    );
  }
}
