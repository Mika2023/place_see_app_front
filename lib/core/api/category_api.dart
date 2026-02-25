import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CategoryApi {
  final Dio dio;

  CategoryApi(this.dio);

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final response = await dio.get(
          '/categories',
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

  Future<List<Map<String, dynamic>>> getAllCategoriesForFilters() async {
    try {
      final response = await dio.get(
        '/categories/filters',
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