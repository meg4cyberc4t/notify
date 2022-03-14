import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:notify/src/methods/passive_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColorPickerView extends StatefulWidget {
  const ColorPickerView({
    required this.title,
    this.initialValue,
    final Key? key,
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
          title: Text(AppLocalizations.of(context)!.chooseYourColor),
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
                    builder: (BuildContext context, Color color, _) => InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: AnimatedContainer(
                            height: 100,
                            width: 100,
                            duration: const Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                widget.title.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(color: color.passive),
                              ),
                            ),
                          ),
                        )),
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
                            child: Text(
                                AppLocalizations.of(context)!.continueButton),
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
                            child:
                                Text(AppLocalizations.of(context)!.backButton),
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
