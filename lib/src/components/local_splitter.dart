import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LocalSplitter extends StatelessWidget {
  const LocalSplitter({
    required this.split,
    required this.splitter,
    required this.child,
    Key? key,
  }) : super(key: key);

  static LocalSplitter withShimmer({
    required BuildContext context,
    required bool isLoading,
    required Widget child,
  }) {
    return LocalSplitter(
      split: isLoading,
      splitter: (Widget child) => Shimmer.fromColors(
        child: child,
        highlightColor: Theme.of(context).textTheme.bodyText2!.color!,
        baseColor: Theme.of(context).hintColor,
      ),
      child: child,
    );
  }

  final bool split;
  final Widget child;
  final Widget Function(Widget child) splitter;
  @override
  Widget build(BuildContext context) => split ? splitter(child) : child;
}
