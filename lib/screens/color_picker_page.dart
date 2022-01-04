// ignore_for_file: public_member_api_docs, prefer_single_quotes

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({
    required this.title,
    final Key? key,
    this.initialValue,
  }) : super(key: key);
  final Color? initialValue;
  final String title;

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('initialValue', initialValue))
      ..add(StringProperty('title', title));
  }
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late Color selectedColor;
  @override
  void initState() {
    selectedColor = widget.initialValue ?? Colors.primaries[0];
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(),
              Text(
                // TODO: Rewrite color picker with AppBar
                "Choose color",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              NotifyAvatar(
                size: AvatarSize.max,
                color: selectedColor,
                title: widget.title,
              ),
              MaterialColorPicker(
                onColorChange: (final Color color) {
                  setState(() => selectedColor = color);
                },
                selectedColor: selectedColor,
                colors: Colors.primaries,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  NotifyDirectButton(
                    title: 'Continue',
                    onPressed: () => Navigator.pop(context, selectedColor),
                  ),
                  const SizedBox(height: 10),
                  NotifyDirectButton(
                    title: 'Back',
                    style: NotifyDirectButtonStyle.outlined,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
  }
}
