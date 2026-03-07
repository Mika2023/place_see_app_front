import 'package:dio/dio.dart';

class UserLocationApi {

  final Dio dio;

  UserLocationApi(this.dio);

  Future<Response> updateLocation(double latitude, double longitude) {
    return dio.post(
        '/user-location/update-location',
        data: {
          'latitude': double.parse(latitude.toStringAsFixed(6)),
          'longitude': double.parse(longitude.toStringAsFixed(6)),
        }
    );
  }
}