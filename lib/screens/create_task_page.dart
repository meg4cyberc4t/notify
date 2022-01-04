// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_text_field.dart';

class CreateNotificationPage extends StatefulWidget {
  const CreateNotificationPage({
    final Key? key,
  }) : super(key: key);

  @override
  State<CreateNotificationPage> createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Create notification')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const NotifyTextField(
                labelText: 'Title',
              ),
              Column(
                children: <Widget>[
                  DropdownButton<String>(
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'check',
                        child: Text('Check'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'check2',
                        child: Text('Check2'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'check3',
                        child: Text('Check'),
                      ),
                    ],
                    onChanged: print,
                    isExpanded: true,
                  ),
                  NotifyDirectButton(
                    title: 'Create',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  NotifyDirectButton(
                    title: 'Back',
                    onPressed: () {},
                    style: NotifyDirectButtonStyle.outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
