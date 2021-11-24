import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/components/widgets/fade_animation.dart';
import 'package:notify/components/widgets/text_button.dart';

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
            FadeAnimation(
              delay: 0.9,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            FadeAnimation(
              delay: 0.9,
              child: AnimatedContainer(
                height: 100,
                width: 100,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "LA".toUpperCase(),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeAnimation(
                delay: 0.95,
                child: MaterialColorPicker(
                  onColorChange: (Color color) {
                    setState(() => selectedColor = color);
                  },
                  selectedColor: selectedColor,
                  colors: Colors.primaries,
                )),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: FadeAnimation(
                delay: 1.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: NotifyTextButton(
                      text: 'Continue',
                      onPressed: () => Navigator.pop(context, selectedColor),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
