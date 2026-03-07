// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  path: (json['path'] as List<dynamic>)
      .map((e) => Point.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalDuration: json['totalDuration'] as String,
);

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'totalDistance': instance.totalDistance,
      'totalDuration': instance.totalDuration,
    };
