import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RepeatMode {
  none,
  everyday,
  everyweek,
  everymonth,
  everyyear,
}

DateTime getRepeatModeNextDateTime(DateTime deadline, RepeatMode rp) =>
    DateTime(
      (rp == RepeatMode.everyyear) ? deadline.year + 1 : deadline.year,
      (rp == RepeatMode.everymonth) ? deadline.month + 1 : deadline.month,
      (rp == RepeatMode.everyday)
          ? deadline.day + 1
          : (rp == RepeatMode.everyweek)
              ? deadline.day + 7
              : deadline.day,
      deadline.hour,
      deadline.minute,
      deadline.second,
    );

String getRepeatModeTitle(BuildContext context, RepeatMode rp) {
  switch (rp) {
    case RepeatMode.none:
      return AppLocalizations.of(context)!.oneTime;
    case RepeatMode.everyday:
      return AppLocalizations.of(context)!.everyDay;
    case RepeatMode.everymonth:
      return AppLocalizations.of(context)!.everyMonth;
    case RepeatMode.everyweek:
      return AppLocalizations.of(context)!.everyWeek;
    case RepeatMode.everyyear:
      return AppLocalizations.of(context)!.everyYear;
  }
}

String getRepeatModeDescription(BuildContext context, RepeatMode rp) {
  switch (rp) {
    case RepeatMode.none:
      return AppLocalizations.of(context)!.oneTimeDescription;
    case RepeatMode.everyday:
      return AppLocalizations.of(context)!.everyDayDescription;
    case RepeatMode.everyweek:
      return AppLocalizations.of(context)!.everyWeekDescription;
    case RepeatMode.everymonth:
      return AppLocalizations.of(context)!.everyMonthDescription;
    case RepeatMode.everyyear:
      return AppLocalizations.of(context)!.everyYearDescription;
  }
}
