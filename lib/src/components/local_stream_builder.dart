import 'package:flutter/material.dart';

class LocalStreamBuilder<T> extends StatelessWidget {
  const LocalStreamBuilder({
    Key? key,
    this.initialData,
    required this.stream,
    required this.onData,
    required this.onError,
    required this.onProgress,
  }) : super(key: key);

  final Stream<T>? stream;
  final T? initialData;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, Object error) onError;
  final Widget Function(BuildContext context) onProgress;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initialData,
      builder: (final BuildContext context, final AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.active) {
          return onData(context, snapshot.data as T);
        }
        if (snapshot.hasError) {
          return onError(context, snapshot.error as Object);
        }
        return onProgress(context);
      },
    );
  }
}
