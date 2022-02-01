import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandBookPage extends StatefulWidget {
  const BrandBookPage({Key? key}) : super(key: key);

  @override
  State<BrandBookPage> createState() => _BrandBookPageState();
}

class _BrandBookPageState extends State<BrandBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Header',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Item 2'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Item 3'),
                onTap: () {},
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Item A'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Header',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Item 2'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Item 3'),
                onTap: () {},
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Item A'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'headline1',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                'headline2',
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                'headline3',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                'headline4',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'headline5',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'headline6',
                style: Theme.of(context).textTheme.headline6,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated'),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Elevated with icon'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text(
                  'OutlinedButton',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('OutlinedButton with icon'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('TextButton'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('TextButton with icon'),
              ),
              ListTile(
                title: const Text('title'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('title'),
                subtitle: const Text('subtitle'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('title'),
                subtitle: const Text('subtitle'),
                leading: const Text('leading'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('title'),
                subtitle: const Text('subtitle'),
                leading: const Text('leading'),
                trailing: const Text('trailling'),
                onTap: () {},
              ),
              CheckboxListTile(
                value: false,
                title: const Text('title'),
                subtitle: const Text('subtitle'),
                onChanged: (value) {},
              ),
              CheckboxListTile(
                value: true,
                title: const Text('title'),
                subtitle: const Text('subtitle'),
                onChanged: (value) {},
              ),
              NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                animationDuration: const Duration(seconds: 500),
                selectedIndex: 1,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.calendar_today_outlined),
                    selectedIcon: Icon(Icons.calendar_today),
                    label: 'Calendar',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search_outlined),
                    selectedIcon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outlined),
                    selectedIcon: Icon(Icons.person),
                    label: 'Person',
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('title'),
                      content: const Text('context'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text(
                            'Hehe',
                          ),
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: () => Navigator.of(context).pop(),
                          isDefaultAction: true,
                        ),
                        CupertinoDialogAction(
                          child: const Text('Not hehe'),
                          isDestructiveAction: true,
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Show alert dialog',
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewPadding.bottom,
                        ),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Share'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.link),
                              title: const Text('Get link'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit name'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete collection'),
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Show modal bottom sheet',
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: const Text('Text label'),
                      action: SnackBarAction(
                        label: 'Action',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Show snack bar',
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                },
                child: const Text(
                  'Show time picker',
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );
                },
                child: const Text(
                  'Show date picker',
                ),
              ),
              Wrap(
                children: [
                  InputChip(
                    avatar: const Icon(Icons.add),
                    label: const Text('Input 1'),
                    onSelected: (bool value) {},
                  ),
                  const SizedBox(width: 10),
                  InputChip(
                    avatar: const Icon(Icons.remove),
                    label: const Text('Input 2'),
                    onSelected: (bool value) {},
                  ),
                ],
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(child: Text('PopupMenuButton A')),
                  const PopupMenuItem(child: Text('PopupMenuButton B')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(child: Text('PopupMenuButton C')),
                  const PopupMenuItem(child: Text('PopupMenuButton D')),
                ],
              ),
              Slider(
                value: 50,
                max: 100,
                label: 'Label',
                onChanged: (value) {},
              ),
              Switch(
                value: true,
                onChanged: (value) {},
              ),
              Switch(
                value: false,
                inactiveThumbColor: Theme.of(context).colorScheme.surface,
                onChanged: (value) {},
              ),
              DropdownButton<int>(
                onChanged: (int? value) {},
                value: 0,
                items: const [
                  DropdownMenuItem(
                    child: Text('DropdownMenuItem A'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('DropdownMenuItem B'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('DropdownMenuItem C'),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text('DropdownMenuItem D'),
                    value: 3,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const LinearProgressIndicator(),
              const SizedBox(height: 10),
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Hint Text'),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Hint Text',
                    labelText: 'Label Text',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Only label',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
