// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_profile_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoProfileInfoImpl _$$PhotoProfileInfoImplFromJson(
  Map<String, dynamic> json,
) => _$PhotoProfileInfoImpl(
  id: (json['id'] as num).toInt(),
  userName: json['userName'] as String?,
  imageUrl: json['imageUrl'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  place: PlaceShortForSearch.fromJson(json['place'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PhotoProfileInfoImplToJson(
  _$PhotoProfileInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
  'place': instance.place,
};
