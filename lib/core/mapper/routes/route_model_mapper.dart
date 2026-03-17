import 'package:place_see_app/core/model/routes/route_model.dart';
import 'package:place_see_app/core/model/routes/route_profile_info.dart';

extension RouteModelMapper on RouteModel {
  RouteProfileInfo toProfileInfo() {
    return RouteProfileInfo(id, name, path, DateTime.now());
  }
}