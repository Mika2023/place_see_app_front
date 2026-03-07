import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_short_for_search.g.dart';

@JsonSerializable()
class PlaceShortForSearch {
  final int id;
  final String name;

  PlaceShortForSearch({ required this.id, required this.name});

  factory PlaceShortForSearch.fromJson(Map<String, dynamic> rawPlace) =>
      _$PlaceShortForSearchFromJson(rawPlace);
}