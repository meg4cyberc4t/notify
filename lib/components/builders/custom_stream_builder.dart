import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/services/notify_parameters.dart';

// ignore_for_file: public_member_api_docs

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    required this.stream,
    required this.onData,
    required this.onError,
    required this.onProgress,
    this.initialData,
    final Key? key,
  }) : super(key: key);

  factory CustomStreamBuilder.notify({
    required final Stream<T> stream,
    required final Widget Function(BuildContext context, T data) onData,
    final Key? key,
  }) =>
      CustomStreamBuilder<T>(
        key: key,
        stream: stream,
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

  factory CustomStreamBuilder.notifySliver({
    required final Stream<T> stream,
    required final Widget Function(BuildContext context, T data) onData,
    final Key? key,
  }) =>
      CustomStreamBuilder<T>(
        key: key,
        stream: stream,
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

  final Stream<T> stream;
  final T? initialData;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, Object? error) onError;
  final Widget Function(BuildContext context) onProgress;

  @override
  Widget build(final BuildContext context) => StreamBuilder<T>(
        stream: stream,
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
        DiagnosticsProperty<Stream<T>>('stream', stream),
      );
    super.debugFillProperties(properties);
  }
}
