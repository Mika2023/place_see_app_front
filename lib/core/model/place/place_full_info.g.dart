// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_full_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceFullInfo _$PlaceFullInfoFromJson(Map<String, dynamic> json) =>
    PlaceFullInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      locationDescription: const TransportMapConverter().fromJson(
        json['locationDescription'] as Map<String, dynamic>,
      ),
      workingHours: const WorkingHoursConverter().fromJson(
        json['workingHours'] as Map<String, dynamic>?,
      ),
      visitCost: (json['visitCost'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagShort.fromJson(e as Map<String, dynamic>))
          .toList(),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => PhotoFullInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryForPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaceFullInfoToJson(
  PlaceFullInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'locationDescription': const TransportMapConverter().toJson(
    instance.locationDescription,
  ),
  'workingHours': const WorkingHoursConverter().toJson(instance.workingHours),
  'visitCost': instance.visitCost,
  'tags': instance.tags,
  'photos': instance.photos,
  'categories': instance.categories,
};
