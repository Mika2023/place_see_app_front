import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:place_see_app/core/converter/transport_map_converter.dart';
import 'package:place_see_app/core/converter/working_hours_converter.dart';
import 'package:place_see_app/core/model/category/category_for_place.dart';
import 'package:place_see_app/core/model/filters/day_enum.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/core/model/tag/tag_short.dart';

part 'place_full_info.g.dart';

@JsonSerializable()
class PlaceFullInfo {
  final int id;
  final String name;
  final String? description;
  final String? address;

  @TransportMapConverter()
  final Map<TransportTypeEnum, List<String>> locationDescription;

  @WorkingHoursConverter()
  final Map<DayEnum, List<Map<String, String>>>? workingHours;

  final double visitCost;
  final List<TagShort>? tags;
  final List<PhotoFullInfo> photos;
  final List<CategoryForPlace> categories;

  PlaceFullInfo({
    required this.id,
    required this.name,
    this.description,
    this.address,
    required this.locationDescription,
    this.workingHours,
    required this.visitCost,
    this.tags,
    required this.photos,
    required this.categories,
  });

  factory PlaceFullInfo.fromJson(Map<String, dynamic> rawPlace) =>
      _$PlaceFullInfoFromJson(rawPlace);
}