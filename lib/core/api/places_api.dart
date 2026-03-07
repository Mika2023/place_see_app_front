import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/model/filters/filters_model.dart';

class PlacesApi {
  final Dio dio;

  PlacesApi(this.dio);

  Future<List<Map<String, dynamic>>> getPlacesByCatId(int catId) async {
    try {
      final response = await dio.post(
        '/places/filters',
        data: {
          'categoryIds': [catId],
        }
      );

      if (response.statusCode == 200) {
        final data = response.data["content"] as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPlacesForSearch() async {
    try {
      final response = await dio.get(
          '/places',
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPlacesByFilters(FiltersModel filters) async {
    try {
      print(filters.toJson());
      final response = await dio.post(
          '/places/filters',
          data: filters.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data["content"] as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchPlaces(String name) async {
    try {
      final response = await dio.post(
          '/places/search',
          data: {
            'name': name,
          }
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<String>> getAllStationsByTransportType(String transportType) async {
    try {
      final response = await dio.get(
        '/places/filters?transportType=$transportType',
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((el) => el as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> getPlaceById(int placeId) async {
    try {
      final response = await dio.get(
        '/places/$placeId'
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

  Future<List<Map<String, dynamic>>> getPlacesNearbyByPlaceId(int placeId) async {
    try {
      final response = await dio.get(
          '/places/$placeId/placesNearby'
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}