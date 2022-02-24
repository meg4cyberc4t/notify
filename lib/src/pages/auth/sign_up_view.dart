// ignore_for_file: prefer_single_quotes

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:notify/src/methods/get_passive_color.dart';
import 'package:notify/src/pages/color_picker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/pages/router_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/notify_api_client_exception.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/sign_up';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  String title = '';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (title.trim().isEmpty) {
      title = AppLocalizations.of(context)!.signUpTitle;
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
                style: TextStyle(color: getPassiveColor(colorValue)),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              background: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: colorValue,
              ),
            ),
            iconTheme: IconThemeData(color: getPassiveColor(colorValue)),
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
                  labelText: AppLocalizations.of(context)!.firstNameTitle,
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
                  labelText: AppLocalizations.of(context)!.lastNameTitle,
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
                            try {
                              await ApiService.user.post(
                                firstname: _firstnameController.text.trim(),
                                lastname: _lastnameController.text.trim(),
                                color: colorValue,
                              );
                            } on NotifyApiClientException catch (e) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(e.localTitle(context))),
                              );
                              debugPrint(e.message);
                              return;
                            }
                            await Navigator.of(context)
                                .pushReplacementNamed(RouterView.routeName);
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
