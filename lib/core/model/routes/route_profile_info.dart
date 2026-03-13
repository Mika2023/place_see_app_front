import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:place_see_app/core/model/routes/point.dart';

part 'route_profile_info.g.dart';

@JsonSerializable()
class RouteProfileInfo {
  final int id;
  final String? name;
  final List<Point> path;
  final DateTime? createdAt;

  RouteProfileInfo(this.id, this.name, this.path, this.createdAt);

  factory RouteProfileInfo.fromJson(Map<String, dynamic> rawRoute) => _$RouteProfileInfoFromJson(rawRoute);
}