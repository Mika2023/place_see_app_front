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
}
