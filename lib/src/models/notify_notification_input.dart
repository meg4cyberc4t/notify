import 'package:notify/src/models/repeat_mode.dart';

class NotifyNotificationInput {
  const NotifyNotificationInput({
    required this.title,
    required this.description,
    required this.repeatMode,
    required this.important,
    required this.deadline,
  });

  final String title;
  final String description;
  final RepeatMode repeatMode;
  final bool important;
  final DateTime deadline;
}
