import 'package:stream_transform/stream_transform.dart';

/// Allows you to connect the results of several streams.
/// If at least one thread changes the value, an iteration will occur.
/// The results of the streams line up side by side, and do not mix each other
Stream<List<T>> combineLatestStreams<T>(
  final Iterable<Stream<T>> streams,
) {
  final Stream<T> first = streams.first.cast<T>();
  final List<Stream<T>> others = <Stream<T>>[...streams.skip(1)];
  return first.combineLatestAll(others);
}
