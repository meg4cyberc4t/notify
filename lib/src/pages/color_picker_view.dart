import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/src/widgets/user_avatar.dart';

class ColorPickerView extends StatefulWidget {
  const ColorPickerView({
    required this.title,
    final Key? key,
    this.initialValue,
  }) : super(key: key);
  final Color? initialValue;
  final String title;

  @override
  State<ColorPickerView> createState() => _ColorPickerViewState();

  static const routeName = '/color_picker';
}

class _ColorPickerViewState extends State<ColorPickerView> {
  late ValueNotifier<Color> selectedColor;

  @override
  void initState() {
    selectedColor = ValueNotifier(widget.initialValue ?? Colors.primaries[0]);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Choose your color'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(), //Space
                ValueListenableBuilder(
                  valueListenable: selectedColor,
                  builder: (BuildContext context, Color value, _) => UserAvatar(
                    size: AvatarSize.max,
                    color: value,
                    title: widget.title.toUpperCase(),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: selectedColor,
                  builder: (BuildContext context, Color value, _) =>
                      MaterialColorPicker(
                    onColorChange: (Color color) {
                      selectedColor.value = color;
                    },
                    selectedColor: value,
                    colors: Colors.primaries,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Continue'),
                            onPressed: () =>
                                Navigator.of(context).pop(selectedColor.value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            child: const Text('Back'),
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
