import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notify/src/components/warnings_view/bad_connection_view.dart';
import 'package:notify/src/components/warnings_view/not_found_view.dart';
import 'package:notify/src/components/warnings_view/unknown_error_view.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';

class LocalFutureBuilder<T> extends StatefulWidget {
  const LocalFutureBuilder({
    Key? key,
    required this.future,
    required this.onData,
    required this.onProgress,
  }) : super(key: key);

  static LocalFutureBuilder withLoading<T>({
    Key? key,
    required Future<T> future,
    required Widget Function(BuildContext context, Object error) onError,
    required Widget Function(BuildContext context, T? data, bool isLoaded)
        onLoading,
  }) {
    return LocalFutureBuilder<T>(
      future: future,
      onData: (BuildContext context, T data) => onLoading(context, data, true),
      onProgress: (BuildContext context) => onLoading(context, null, false),
    );
  }

  final Future<T> future;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context) onProgress;

  static Widget onError(BuildContext context, Object error,
      [VoidCallback? callback]) {
    if (error is ApiServiceException && error.statusCode == 404) {
      return const NotFoundView();
    }
    if (error is SocketException) {
      return BadConnectionView(callback: callback);
    }
    debugPrint('Error in loading: ' + error.toString());
    return const UnknownErrorView();
  }

  @override
  State<LocalFutureBuilder<T>> createState() => _LocalFutureBuilderState<T>();
}

class _LocalFutureBuilderState<T> extends State<LocalFutureBuilder<T>> {
  Widget onErrorWithCallback(BuildContext context, Object error) {
    return LocalFutureBuilder.onError(context, error, () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (final BuildContext context, final AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return widget.onData(context, snapshot.data!);
        }
        if (snapshot.hasError) {
          return LocalFutureBuilder.onError(context, snapshot.error!);
        }
        return widget.onProgress(context);
      },
    );
  }
}
