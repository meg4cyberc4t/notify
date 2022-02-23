import 'package:json_annotation/json_annotation.dart';

part 'notify_folder_detailed.g.dart';

@JsonSerializable()
class NotifyFolderDetailed {
  const NotifyFolderDetailed({
    required this.id,
    required this.title,
    required this.description,
    required this.participantsCount,
    required this.notificationsCount,
  });

  factory NotifyFolderDetailed.fromJson(Map<String, dynamic> json) =>
      _$NotifyFolderDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyFolderDetailedToJson(this);

  final String id;
  final String title;
  final String description;
  final int participantsCount;
  final int notificationsCount;
}
