import 'package:json_annotation/json_annotation.dart';
import 'package:notify/src/models/repeat_mode.dart';

class RepeatModeSerialiser implements JsonConverter<RepeatMode, int> {
  const RepeatModeSerialiser();

  @override
  RepeatMode fromJson(int json) => RepeatMode.values[json];

  @override
  int toJson(RepeatMode object) => object.index;
}
