import 'package:json_annotation/json_annotation.dart';

import '../model/filters/day_enum.dart';

class WorkingHoursConverter implements JsonConverter<Map<DayEnum, List<Map<String, String>>>?, Map<String, dynamic>?>{
  const WorkingHoursConverter();

  @override
  Map<DayEnum, List<Map<String, String>>>? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return json.map((key, value) => MapEntry(
      DayEnum.values.firstWhere((e) => e.name.toLowerCase().startsWith(key)),
      List<Map<String, String>>.from(
          (value as List).map((e) => Map<String, String>.from(e))
      )
    ));
  }

  @override
  Map<String, dynamic>? toJson(Map<DayEnum, List<Map<String, String>>>? object) {
    return null;
  }
}