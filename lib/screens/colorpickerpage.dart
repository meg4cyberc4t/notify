import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/components/widgets/avatar.dart';
import 'package:notify/components/widgets/direct_button.dart';

Future<Color> pushColorPickerPage(
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose color",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Avatar(
              size: AvatarSize.max,
              color: selectedColor,
              title: widget.title,
            ),
            const SizedBox(height: 10),
            MaterialColorPicker(
              onColorChange: (Color color) {
                setState(() => selectedColor = color);
              },
              selectedColor: selectedColor,
              colors: Colors.primaries,
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: NotifyDirectButton.text(
                    text: 'Continue',
                    onPressed: () => Navigator.pop(context, selectedColor),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: NotifyDirectButton.text(
                    text: 'Back',
                    onPressed: () => Navigator.pop(context),
                    isOutlined: true,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
