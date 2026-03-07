import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';
import 'package:place_see_app/core/model/routes/route_transport_type_enum.dart';

class RouteApi {
  final Dio dio;

  RouteApi(this.dio);

  Future<Map<String, dynamic>> createAndGetRoute(int toPlaceId, RouteTransportTypeEnum transportType) async {
    try {
      print("Creating ROUTE ID: $toPlaceId");
      final response = await dio.post(
        '/routes',
        data: {
          'toPlaceId': toPlaceId,
          'transportType': transportType.name
        }
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }

  Future<Map<String, dynamic>> editRoute(int? fromPlaceId, int? toPlaceId, int routeId, RouteTransportTypeEnum transportType) async {
    try {
      print("EDITING ROUTE ID: $routeId");
      final response = await dio.post(
          '/routes/$routeId',
          data: {
            'toPlaceId': toPlaceId,
            'fromPlaceId': fromPlaceId,
            'transportType': transportType.name
          }
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }
}