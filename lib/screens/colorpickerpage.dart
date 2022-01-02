import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/components/widgets/notify_user_avatar.dart';
import 'package:notify/components/widgets/notify_direct_button.dart';

Future<Color?> pushColorPickerPage(
    BuildContext context, String title, Color initialValue) async {
  Color? color = await Navigator.push<Color?>(
    context,
    Platform.isAndroid
        ? MaterialPageRoute<Color?>(
            builder: (context) => ColorPickerPage(
                  title: title,
                  initialValue: initialValue,
                ))
        : CupertinoPageRoute<Color?>(
            builder: (context) => ColorPickerPage(
              title: title,
              initialValue: initialValue,
            ),
          ),
  );
  return Future.value(color);
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key, this.initialValue, required this.title})
      : super(key: key);
  final Color? initialValue;
  final String title;

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late Color selectedColor;
  @override
  void initState() {
    selectedColor = widget.initialValue ?? Colors.primaries[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            onColorChange: (Color color) {
              setState(() => selectedColor = color);
            },
            selectedColor: selectedColor,
            colors: Colors.primaries,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
    ));
  }
}
