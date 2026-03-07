import 'package:freezed_annotation/freezed_annotation.dart';

part 'point.g.dart';

@JsonSerializable()
class Point {
  final double latitude;
  final double longitude;

  Point({
    required this.latitude,
    required this.longitude
  });

  factory Point.fromJson(Map<String, dynamic> rawPoint) =>
      _$PointFromJson(rawPoint);
}