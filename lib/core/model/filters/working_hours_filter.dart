import 'package:place_see_app/core/model/filters/day_enum.dart';

class WorkingHoursFilter {
  final Set<DayEnum>? openDays;
  final String? from;
  final String? to;

  WorkingHoursFilter({
    required this.openDays,
    this.from,
    this.to,
  });

  Map<String, dynamic> toJson() => {
    "openDays": openDays?.map((el) => el.name).toList(),
    "from": from,
    "to": to,
  };

}