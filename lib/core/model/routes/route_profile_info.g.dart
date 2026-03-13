// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_profile_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteProfileInfo _$RouteProfileInfoFromJson(Map<String, dynamic> json) =>
    RouteProfileInfo(
      (json['id'] as num).toInt(),
      json['name'] as String?,
      (json['path'] as List<dynamic>)
          .map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RouteProfileInfoToJson(RouteProfileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
