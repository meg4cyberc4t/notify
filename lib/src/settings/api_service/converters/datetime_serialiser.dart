import 'package:json_annotation/json_annotation.dart';

class DateTimeSerialiser implements JsonConverter<DateTime, String> {
  const DateTimeSerialiser();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
