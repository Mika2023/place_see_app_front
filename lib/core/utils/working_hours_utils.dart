import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/filters/day_enum.dart';
import 'package:place_see_app/core/model/filters/working_hours_state.dart';

class WorkingHoursUtils {
  static String workingHoursString(WorkingHoursState state) {
    final days = state.openDays.map(dayShort).join(', ');
    final from = state.from != null ? formatDate(state.from!) : '00:00';
    final to = state.to != null ? formatDate(state.to!) : '23:59';

    if (days.isEmpty && state.from == null && state.to == null) return 'Любое';

    return '${days.isEmpty ? '' : '$days · '}$from - $to';
  }

  static String formatDate(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  static String dayShort(DayEnum day) {
    const map = {
      DayEnum.monday: 'Пн',
      DayEnum.tuesday: 'Вт',
      DayEnum.wednesday: 'Ср',
      DayEnum.thursday: 'Чт',
      DayEnum.friday: 'Пт',
      DayEnum.saturday: 'Сб',
      DayEnum.sunday: 'Вс',
    };

    return map[day]!;
  }

  static String dayFull(DayEnum day) {
    const map = {
      DayEnum.monday: 'Понедельник',
      DayEnum.tuesday: 'Вторник',
      DayEnum.wednesday: 'Среда',
      DayEnum.thursday: 'Четверг',
      DayEnum.friday: 'Пятница',
      DayEnum.saturday: 'Суббота',
      DayEnum.sunday: 'Воскресенье',
    };

    return map[day]!;
  }

  static DayEnum fromString(String weekDay) {
    return DayEnum.values.firstWhere((e) => e.name.toLowerCase() == weekDay, orElse: () => DayEnum.monday);
  }

  static DayEnum fromInt(int weekDay) {
    if (weekDay <= 0 || weekDay > 7) return DayEnum.monday;

    return DayEnum.values[weekDay-1];
  }

  static String formatToPeriod(List<Map<String, String>> hours) {
    return hours.map((hourPeriod) => '${hourPeriod['from']}-${hourPeriod['to']}').join(', ');
  }

  static Map<DayEnum, List<Map<String, String>>>? formatWorkingHoursToMap(Map<DayEnum, List<Map<String, String>>>? workingHours) {
    if (workingHours == null) return null;

    return workingHours.map((key, value) {
      final todayHours = value;
      final nextDay = DayEnum.values[(key.index + 1) % DayEnum.values.length];
      final nextDayHours = workingHours[nextDay] ?? [];
      final prevDay = key.index == 0 ? DayEnum.sunday : DayEnum.values[key.index-1];
      final prevDayHours = workingHours[prevDay] ?? [];

      List<Map<String, String>> periods = [];

      for (var period in todayHours) {
        String from = period['from']!;
        String to = period['to']!;

        var prevDayPeriod = prevDayHours.firstWhere((p) => p['to'] == '24:00', orElse: () => {});
        if (prevDayPeriod.isNotEmpty && from == '00:00' && to.compareTo('23:59') < 0) continue;

        if (to == '24:00') {
          var nextDayPeriod = nextDayHours.firstWhere((p) => p['from'] == '00:00', orElse: () => {});
          if (nextDayPeriod.isNotEmpty) to = nextDayPeriod['to']!;
        }

        periods.add({'from':from, 'to':to});
      }

      return MapEntry(key, periods);
    });
  }

  static bool checkIfWorking24On7(Map<DayEnum, List<Map<String, String>>> workingHours) {
    if (workingHours.isEmpty) return false;

    for (var day in workingHours.keys) {
      final period = workingHours[day] ?? [];

      if (period.isEmpty) return false;

      final allDayPeriod = period.firstWhere((p) => p['from'] == '00:00' && p['to']!.compareTo('23:58') > 0, orElse: () => {});
      if (allDayPeriod.isEmpty) return false;
    }

    return true;
  }
}
