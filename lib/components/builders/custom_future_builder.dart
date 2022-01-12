import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/services/notify_parameters.dart';

// ignore_for_file: public_member_api_docs

class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    required this.future,
    required this.onData,
    required this.onError,
    required this.onProgress,
    this.initialData,
    final Key? key,
  }) : super(key: key);

  factory CustomFutureBuilder.notify({
    required final Future<T> future,
    required final Widget Function(BuildContext context, T data) onData,
    final Key? key,
  }) =>
      CustomFutureBuilder<T>(
        key: key,
        future: future,
        onData: onData,
        onError: (final BuildContext _, final Object? error) => Center(
          child: Text(
            error.toString(),
          ),
        ),
        onProgress: (final BuildContext _) => const Center(
          child: CircularProgressIndicator(
            strokeWidth: NotifyParameters.circularProgressIndicatorWidth,
          ),
        ),
      );

  factory CustomFutureBuilder.notifySliver({
    required final Future<T> future,
    required final Widget Function(BuildContext context, T data) onData,
    final Key? key,
  }) =>
      CustomFutureBuilder<T>(
        key: key,
        future: future,
        onData: onData,
        onError: (final BuildContext _, final Object? error) =>
            SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Center(
              child: Text(
                error.toString(),
              ),
            ),
          ),
        ),
        onProgress: (final BuildContext _) => const SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: NotifyParameters.circularProgressIndicatorWidth,
              ),
            ),
          ),
        ),
      );

  final Future<T> future;
  final T? initialData;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, Object? error) onError;
  final Widget Function(BuildContext context) onProgress;

  @override
  Widget build(final BuildContext context) => FutureBuilder<T>(
        future: future,
        initialData: initialData,
        builder:
            (final BuildContext context, final AsyncSnapshot<T?> snapshot) {
          if (snapshot.hasData) {
            return onData(context, snapshot.data!);
          }
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              final T? data = snapshot.data;
              if (snapshot.hasError || data == null) {
                return onError(context, snapshot.error);
              }
              return onData(context, data);
            case ConnectionState.done:
              final T? data = snapshot.data;
              if (snapshot.hasError || data == null) {
                return onError(context, snapshot.error);
              }
              return onData(context, data);
            case ConnectionState.waiting:
              return onProgress(context);
            case ConnectionState.none:
          }
          return Container();
        },
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    properties
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext context)>.has(
          'onProgress',
          onProgress,
        ),
      )
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext context, T data)>.has(
          'onData',
          onData,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Widget Function(
          BuildContext context,
          Object? error,
        )>.has('onError', onError),
      )
      ..add(DiagnosticsProperty<T?>('initialData', initialData))
      ..add(
        DiagnosticsProperty<Future<T>>('future', future),
      );
    super.debugFillProperties(properties);
  }
}
