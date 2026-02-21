import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_card.freezed.dart';
part 'place_card.g.dart';

@freezed
class PlaceCard with _$PlaceCard{
  const factory PlaceCard({
    required int id,
    required String name,
    bool? isFavorite,
    String? mainImageUrl
  }) = _PlaceCard;

  factory PlaceCard.fromJson(Map<String, dynamic> json) => _$PlaceCardFromJson(json);
}