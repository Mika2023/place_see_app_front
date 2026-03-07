import 'package:latlong2/latlong.dart';
import 'package:place_see_app/core/model/routes/point.dart';

class PointUtils {
  static Point toPointFromLatLong(LatLng position) {
    return Point(latitude: position.latitude, longitude: position.longitude);
  }

  static LatLng toLatLngFromPoint(Point position) {
    return LatLng(position.latitude, position.longitude);
  }
}