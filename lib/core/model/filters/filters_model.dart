import 'package:place_see_app/core/model/filters/working_hours_filter.dart';

class FiltersModel {
  final double? minPrice;
  final double? maxPrice;
  final Set<int>? categoryIds;
  final Map<String, Set<String>>? selectedStops;
  final WorkingHoursFilter? workingHoursFilter;
  final bool? isFavoriteByUser;
  final Set<int>? tagIds;

  final String? sort;
  final int? page;
  final int? size;

  FiltersModel({
    this.minPrice,
    this.maxPrice,
    this.categoryIds,
    this.selectedStops,
    this.workingHoursFilter,
    this.isFavoriteByUser,
    this.sort,
    this.page,
    this.size,
    this.tagIds
  });

  Map<String, dynamic> toJson() => _removeNulls({
    "minPrice": minPrice,
    "maxPrice": maxPrice,
    "categoryIds": categoryIds?.toList(),
    "selectedStops": selectedStops,
    "workingHours": workingHoursFilter?.toJson(),
    "isFavoriteByUser": isFavoriteByUser,
    "tagIds": tagIds?.toList(),
    "sort": sort,
    "page": page,
    "size": size
  });

  Map<String, dynamic> _removeNulls(Map<String, dynamic> json) {
    Map<String, dynamic> result = {};

    json.forEach((key, value) {
      if (value == null) return;

      if (value is Map<String, dynamic>) {
        final cleaned = _removeNulls(value);
        if (cleaned.isNotEmpty) result[key] = cleaned;
        return;
      }

      if (value is Iterable) {
        final cleanedList = value.where((e) => e != null).toList();
        if (cleanedList.isNotEmpty) result[key] = cleanedList;
        return;
      }

      result[key] = value;
    });

    return result;
  }
}