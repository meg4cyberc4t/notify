import 'package:flutter/material.dart';

class LocalFutureBuilder<T> extends StatelessWidget {
  const LocalFutureBuilder({
    Key? key,
    required this.future,
    required this.onData,
    required this.onError,
    required this.onProgress,
  }) : super(key: key);

  static LocalFutureBuilder withLoading<T>({
    Key? key,
    required Future<T>? future,
    required Widget Function(BuildContext context, Object error) onError,
    required Widget Function(BuildContext context, T? data, bool isLoaded)
        onLoading,
  }) {
    return LocalFutureBuilder<T>(
      future: future,
      onData: (BuildContext context, T data) => onLoading(context, data, true),
      onProgress: (BuildContext context) => onLoading(context, null, false),
      onError: onError,
    );
  }

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
