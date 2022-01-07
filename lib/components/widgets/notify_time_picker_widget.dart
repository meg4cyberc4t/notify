// ignore_for_file: public_member_api_docs, diagnostic_describe_all_properties

import 'dart:math';

import 'package:flutter/material.dart';

class ItemScrollPhysics extends ScrollPhysics {
  const ItemScrollPhysics({
    final ScrollPhysics? parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
  }) : super(parent: parent);

  /// Creates physics for snapping to item.
  /// Based on PageScrollPhysics
  final double? itemHeight;
  final double targetPixelsLimit;

  @override
  ItemScrollPhysics applyTo(final ScrollPhysics? ancestor) => ItemScrollPhysics(
        parent: buildParent(ancestor),
        itemHeight: itemHeight,
      );

  double _getItem(final ScrollPosition position) {
    final double maxScrollItem =
        (position.maxScrollExtent / itemHeight!).floorToDouble();
    return min(max(0, position.pixels / itemHeight!), maxScrollItem);
  }

  double _getPixels(final ScrollPosition position, final double item) =>
      item * itemHeight!;

  double _getTargetPixels(
    final ScrollPosition position,
    final Tolerance tolerance,
    final double velocity,
  ) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= targetPixelsLimit;
    } else if (velocity > tolerance.velocity) {
      item += targetPixelsLimit;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
    final ScrollMetrics position,
    final double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a item boundary.
//    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
//        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
//      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target =
        _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

typedef SelectedIndexCallback = void Function(int);
typedef TimePickerCallback = void Function(DateTime);

class TimePickerSpinner extends StatefulWidget {
  const TimePickerSpinner({
    required final this.onTimeChange,
    final Key? key,
    final this.time,
    final this.is24HourMode = true,
    final this.isShowSeconds = false,
    final this.highlightedTextStyle = const TextStyle(
      fontSize: 32,
      color: Colors.black,
    ),
    final this.normalTextStyle = const TextStyle(
      fontSize: 32,
      color: Colors.black54,
    ),
    final this.itemHeight = 60,
    final this.itemWidth = 45,
    final this.alignment = Alignment.center,
    final this.spacing = 20,
    final this.isForce2Digits = false,
  }) : super(key: key);
  final DateTime? time;
  final bool is24HourMode;
  final bool isShowSeconds;
  final TextStyle? highlightedTextStyle;
  final TextStyle? normalTextStyle;
  final double itemHeight;
  final double itemWidth;
  final AlignmentGeometry alignment;
  final double spacing;
  final bool isForce2Digits;
  final TimePickerCallback onTimeChange;

  @override
  TimePickerSpinnerState createState() => TimePickerSpinnerState();
}

class TimePickerSpinnerState extends State<TimePickerSpinner> {
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();
  ScrollController secondController = ScrollController();
  ScrollController apController = ScrollController();
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int currentSelectedAPIndex = -1;
  DateTime? currentTime;
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;
  bool isAPScrolling = false;

  bool isLoop(final int value) => value > 10;

  int get _getHourCount => widget.is24HourMode ? 24 : 12;

  DateTime get datetime {
    int hour = currentSelectedHourIndex - _getHourCount;
    if (!widget.is24HourMode && currentSelectedAPIndex == 2) {
      hour += 12;
    }
    final int minute = currentSelectedMinuteIndex - 60 * 60;
    final int second = currentSelectedSecondIndex - 60 * 60;
    return DateTime(
      currentTime!.year,
      currentTime!.month,
      currentTime!.day,
      hour,
      minute,
      second,
    );
  }

  @override
  void initState() {
    currentTime = widget.time;

    currentSelectedHourIndex =
        (currentTime!.hour % (widget.is24HourMode ? 24 : 12)) + _getHourCount;
    hourController = ScrollController(
      initialScrollOffset: (currentSelectedHourIndex - 1) * widget.itemHeight,
    );

    currentSelectedMinuteIndex = currentTime!.minute + 60;
    minuteController = ScrollController(
      initialScrollOffset: (currentSelectedMinuteIndex - 1) * widget.itemHeight,
    );
    currentSelectedSecondIndex = currentTime!.second + 60;
    secondController = ScrollController(
      initialScrollOffset: (currentSelectedSecondIndex - 1) * widget.itemHeight,
    );

    currentSelectedAPIndex = currentTime!.hour >= 12 ? 2 : 1;
    apController = ScrollController(
      initialScrollOffset: (currentSelectedAPIndex - 1) * widget.itemHeight,
    );

    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((final _) => widget.onTimeChange(datetime));
  }

  @override
  Widget build(final BuildContext context) {
    final List<Widget> contents = <Widget>[
      Column(
        children: <Widget>[
          SizedBox(
            width: widget.itemWidth,
            height: widget.itemHeight * 3,
            child: spinner(
              controller: hourController,
              max: _getHourCount,
              selectedIndex: currentSelectedHourIndex,
              isScrolling: isHourScrolling,
              onUpdateSelectedIndex: (final int index) {
                currentSelectedHourIndex = index;
                isHourScrolling = true;
              },
              onScrollEnd: () => isHourScrolling = false,
            ),
          ),
        ],
      ),
      spacer,
      Column(
        children: <Widget>[
          SizedBox(
            width: widget.itemWidth,
            height: widget.itemHeight * 3,
            child: spinner(
              controller: minuteController,
              max: 60,
              selectedIndex: currentSelectedMinuteIndex,
              isScrolling: isMinuteScrolling,
              onUpdateSelectedIndex: (final int index) {
                currentSelectedMinuteIndex = index;
                isMinuteScrolling = true;
              },
              onScrollEnd: () => isMinuteScrolling = false,
            ),
          ),
        ],
      ),
    ];

    if (widget.isShowSeconds) {
      contents
        ..add(spacer)
        ..add(
          Column(
            children: <Widget>[
              SizedBox(
                width: widget.itemWidth,
                height: widget.itemHeight * 3,
                child: spinner(
                  controller: secondController,
                  max: 60,
                  selectedIndex: currentSelectedSecondIndex,
                  isScrolling: isSecondsScrolling,
                  onUpdateSelectedIndex: (final int index) {
                    currentSelectedSecondIndex = index;
                    isSecondsScrolling = true;
                  },
                  onScrollEnd: () => isSecondsScrolling = false,
                ),
              ),
            ],
          ),
        );
    }

    if (!widget.is24HourMode) {
      contents
        ..add(spacer)
        ..add(
          SizedBox(
            width: widget.itemWidth * 1.2,
            height: widget.itemHeight * 3,
            child: apSpinner(),
          ),
        );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  Widget get spacer => SizedBox(
        width: widget.spacing,
        height: widget.itemHeight * 3,
      );

  Widget spinner({
    required final ScrollController controller,
    required final int max,
    required final int selectedIndex,
    required final bool isScrolling,
    required final SelectedIndexCallback onUpdateSelectedIndex,
    required final VoidCallback onScrollEnd,
  }) {
    /// wrapping the spinner with stack and add container above it when it's
    /// scrolling
    /// this thing is to prevent an error causing by some weird stuff like this
    /// flutter: Another exception was thrown:
    /// 'package:flutter/src/widgets/scrollable.dart': Failed assertion:
    /// line 469 pos 12: '_hold == null || _drag == null': is not true.
    /// maybe later we can find out why this error is happening

    final Widget _spinner = NotificationListener<ScrollNotification>(
      onNotification: (final ScrollNotification scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() ==
              'ScrollDirection.idle') {
            if (isLoop(max)) {
              final int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller
                    .jumpTo(controller.offset + (max * widget.itemHeight));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller
                    .jumpTo(controller.offset - (max * widget.itemHeight));
              }
            }
            setState(() {
              onScrollEnd();
              widget.onTimeChange(datetime);
            });
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            onUpdateSelectedIndex(
              (controller.offset / widget.itemHeight).round() + 1,
            );
          });
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (final BuildContext context, final int index) {
          String text = '';
          if (isLoop(max)) {
            text = (index % max).toString();
          } else if (index != 0 && index != max + 1) {
            text = ((index - 1) % max).toString();
          }
          if (!widget.is24HourMode &&
              controller == hourController &&
              text == '0') {
            text = '12';
          }
          if (widget.isForce2Digits && text != '') {
            text = text.padLeft(2, '0');
          }
          return Container(
            height: widget.itemHeight,
            alignment: widget.alignment,
            child: Text(
              text,
              style: selectedIndex == index
                  ? widget.highlightedTextStyle
                  : widget.normalTextStyle,
            ),
          );
        },
        controller: controller,
        itemCount: isLoop(max) ? max * 3 : max + 2,
        physics: ItemScrollPhysics(itemHeight: widget.itemHeight),
        padding: EdgeInsets.zero,
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: _spinner),
        if (isScrolling)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          )
        else
          const SizedBox()
      ],
    );
  }

  Widget apSpinner() {
    final Widget _spinner = NotificationListener<ScrollNotification>(
      onNotification: (final ScrollNotification scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() ==
              'ScrollDirection.idle') {
            isAPScrolling = false;
            widget.onTimeChange(datetime);
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            currentSelectedAPIndex =
                (apController.offset / widget.itemHeight).round() + 1;
            isAPScrolling = true;
          });
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (final BuildContext context, final int index) {
          final String text = index == 1 ? 'AM' : (index == 2 ? 'PM' : '');
          return Container(
            height: widget.itemHeight,
            alignment: Alignment.center,
            child: Text(
              text,
              style: currentSelectedAPIndex == index
                  ? widget.highlightedTextStyle
                  : widget.normalTextStyle,
            ),
          );
        },
        controller: apController,
        itemCount: 4,
        physics: ItemScrollPhysics(
          itemHeight: widget.itemHeight,
          targetPixelsLimit: 1,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: _spinner),
        if (isAPScrolling) Positioned.fill(child: Container()) else Container()
      ],
    );
  }
}
