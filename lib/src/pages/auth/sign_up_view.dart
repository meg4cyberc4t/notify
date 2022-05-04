import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/pages/router_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String title = '';
  bool spamButtonProtection = false;

  late Color colorValue;

  String get shortTitle {
    String localTitle = '';
    if (_firstnameController.text.isNotEmpty) {
      localTitle += _firstnameController.text[0];
    }
    if (_lastnameController.text.isNotEmpty) {
      localTitle += _lastnameController.text[0];
    }
    return localTitle.trim();
  }

  String get longTitle {
    String localTitle = '';
    if (_firstnameController.text.isNotEmpty) {
      localTitle += _firstnameController.text;
    }
    localTitle += ' ';
    if (_lastnameController.text.isNotEmpty) {
      localTitle += _lastnameController.text;
    }
    return localTitle.trim();
  }

  void updateTitleIfUpdate() {
    setState(() {
      title =
          (_firstnameController.text + ' ' + _lastnameController.text).trim();
    });
  }

  @override
  void initState() {
    colorValue = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    _firstnameController.addListener(updateTitleIfUpdate);
    _lastnameController.addListener(updateTitleIfUpdate);
    final DateTime dtn = DateTime.now();
    _statusController.text = 'Hello! I have been using notify since '
        '${DateFormat.MMMM().format(dtn)} '
        '${dtn.day}, ${dtn.year}!';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty) {
      title = AppLocalizations.of(context)!.signUp;
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorValue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: TextStyle(color: colorValue.passive),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              background: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: colorValue,
              ),
            ),
            iconTheme: IconThemeData(color: colorValue.passive),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final Color? newValue = await Navigator.of(context)
                      .pushNamed(ColorPickerView.routeName, arguments: {
                    'title': shortTitle.isNotEmpty ? shortTitle : 'SU',
                    'color': colorValue,
                  });
                  if (newValue == null) {
                    return;
                  }
                  setState(() => colorValue = newValue);
                },
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _firstnameController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.firstname,
                  counterText: '',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _lastnameController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.lastname,
                  counterText: '',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _statusController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.status,
                  counterText: '',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (spamButtonProtection) return;
                            try {
                              spamButtonProtection = true;
                              await ApiService.user.post(
                                firstname: _firstnameController.text.trim(),
                                lastname: _lastnameController.text.trim(),
                                status: _statusController.text.trim(),
                                color: colorValue,
                              );
                              while (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                              await Navigator.of(context)
                                  .popAndPushNamed(RouterView.routeName);
                            } on ApiServiceException catch (e) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(e.message.toString())),
                              );
                              debugPrint(e.message);
                            }
                            spamButtonProtection = false;
                          },
                          child: Text(
                              AppLocalizations.of(context)!.continueButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
