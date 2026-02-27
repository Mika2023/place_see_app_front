import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_for_place.g.dart';

@JsonSerializable()
class CategoryForPlace {
  final int id;
  final String name;

  CategoryForPlace({
    required this.id,
    required this.name,
  });

  factory CategoryForPlace.fromJson(Map<String, dynamic> rawPlace) =>
      _$CategoryForPlaceFromJson(rawPlace);
}