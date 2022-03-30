import 'package:json_annotation/json_annotation.dart';

part 'notify_folder_quick.g.dart';

@JsonSerializable()
class NotifyFolderQuick {
  const NotifyFolderQuick({
    required this.id,
    required this.title,
    required this.description,
    required this.participantsCount,
    required this.notificationsCount,
  });

  factory NotifyFolderQuick.fromJson(Map<String, dynamic> json) =>
      _$NotifyFolderQuickFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyFolderQuickToJson(this);

  final String id;
  final String title;
  final String description;
  final int participantsCount;
  final int notificationsCount;
}
