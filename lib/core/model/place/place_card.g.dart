// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceCardImpl _$$PlaceCardImplFromJson(Map<String, dynamic> json) =>
    _$PlaceCardImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isFavorite: json['isFavorite'] as bool?,
      mainImageUrl: json['mainImageUrl'] as String?,
    );

Map<String, dynamic> _$$PlaceCardImplToJson(_$PlaceCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isFavorite': instance.isFavorite,
      'mainImageUrl': instance.mainImageUrl,
    };
