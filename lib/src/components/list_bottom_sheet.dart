import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_user_quick.dart';

showListUsersBottomSheet({
  required final BuildContext context,
  required final String title,
  required final List<NotifyUserQuick> users,
}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                child: Align(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Divider(),
              ...users.map(
                (e) => ListTile(
                  onTap: () {},
                  leading: Container(
                    decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Text(e.shortTitle)),
                    height: 40,
                    width: 40,
                  ),
                  title: Text(e.title),
                ),
              )
            ],
          ),
        );
      });
}
