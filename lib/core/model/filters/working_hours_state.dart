import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/filters/working_hours_filter.dart';
import 'package:place_see_app/core/utils/working_hours_utils.dart';

import 'day_enum.dart';

class WorkingHoursState {
  Set<DayEnum> openDays = {};
  TimeOfDay? from;
  TimeOfDay? to;

  void reset() {
    openDays = {};
    from = null;
    to = null;
  }

  WorkingHoursState({
    Set<DayEnum>? openDays,
    this.from,
    this.to
  }) : openDays = openDays ?? {};

  WorkingHoursFilter? toDto() {
    return (from != null || to != null || openDays.isNotEmpty) ?
    WorkingHoursFilter(
      openDays: openDays.isEmpty ? null : openDays,
      from: from == null ? null : WorkingHoursUtils.formatDate(from!),
      to: to == null ? null : WorkingHoursUtils.formatDate(to!),
    ) : null;
  }
}