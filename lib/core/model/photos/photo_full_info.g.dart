// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_full_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoFullInfo _$PhotoFullInfoFromJson(Map<String, dynamic> json) =>
    PhotoFullInfo(
      (json['id'] as num).toInt(),
      (json['placeId'] as num).toInt(),
      json['userName'] as String,
      json['imageUrl'] as String,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['isMain'] as bool,
      json['placeName'] as String?,
    );

Map<String, dynamic> _$PhotoFullInfoToJson(PhotoFullInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeId': instance.placeId,
      'userName': instance.userName,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isMain': instance.isMain,
      'placeName': instance.placeName,
    };
