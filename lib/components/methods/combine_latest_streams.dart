import 'package:stream_transform/stream_transform.dart';

Stream<List> combineLatestStreams(Iterable<Stream<Object>> streams) {
  final Stream<Object> first = streams.first.cast<Object>();
  final List<Stream<Object>> others = [...streams.skip(1)];
  return first.combineLatestAll(others);
}
