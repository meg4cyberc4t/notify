import 'package:notify/src/notify_api_client/models/repeat_mode.dart';
import 'package:json_annotation/json_annotation.dart';

class RepeatModeSerialiser implements JsonConverter<RepeatMode, int> {
  const RepeatModeSerialiser();

  @override
  RepeatMode fromJson(int json) => RepeatMode.values[json];

  @override
  int toJson(RepeatMode object) => object.index;
}
