enum RepeatMode {
  none,
  everyday,
  everyweek,
  everymonth,
  everyyear,
}

String getRepeatModeTitle(RepeatMode rp) {
  switch (rp) {
    case RepeatMode.none:
      return 'One-time';
    case RepeatMode.everyday:
      return 'Every day';
    case RepeatMode.everymonth:
      return 'Every month';
    case RepeatMode.everyweek:
      return 'Every week';
    case RepeatMode.everyyear:
      return 'Every year';
  }
}

String getRepeatModeDescription(RepeatMode rp) {
  switch (rp) {
    case RepeatMode.none:
      return 'We will remind you of the reminder only once';
    case RepeatMode.everyday:
      return 'We will remind you at the specified time';
    case RepeatMode.everymonth:
      return 'We will remind you at the specified time and day of the week';
    case RepeatMode.everyweek:
      return 'Remind yourself of this in the coming months';
    case RepeatMode.everyyear:
      return 'Reminder once a year!';
  }
}
