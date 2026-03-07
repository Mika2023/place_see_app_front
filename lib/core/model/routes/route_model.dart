import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:place_see_app/core/model/routes/point.dart';

part 'route_model.g.dart';

@JsonSerializable()
class RouteModel {
  final int id;
  final String? name;
  final List<Point> path;
  final int totalDistance;
  //уже в нужном формате dч. dмин.
  final String totalDuration;

  RouteModel({
    required this.id,
    this.name,
    required this.path,
    required this.totalDistance,
    required this.totalDuration
  });

  factory RouteModel.fromJson(Map<String, dynamic> rawRoute) =>
      _$RouteModelFromJson(rawRoute);
}