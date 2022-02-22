import 'package:flutter/material.dart';

class LocalFutureBuilder<T> extends StatelessWidget {
  const LocalFutureBuilder({
    Key? key,
    this.future,
    required this.onData,
    required this.onError,
    required this.onProgress,
  }) : super(key: key);

  final Future<T>? future;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, Object error) onError;
  final Widget Function(BuildContext context) onProgress;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (final BuildContext context, final AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return onData(context, snapshot.data!);
        }
        if (snapshot.hasError) {
          return onError(context, snapshot.error!);
        }
        return onProgress(context);
      },
    );
  }
}
