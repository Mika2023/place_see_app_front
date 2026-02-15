import 'dart:math';
import 'dart:ui';

import 'package:place_see_app/core/api/category_api.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

import '../../../../core/model/category/category.dart';

class CategoryService {
  final CategoryApi _categoryApi;
  final Random _rand = Random();
  final List<Color> _colorsAvailable = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accentOne,
    AppColors.accentTwo
  ];

  CategoryService(this._categoryApi);

  Future<List<Category>> loadCategories() async {
    final rawCategories = await _categoryApi.getAllCategories();

    if (rawCategories.isEmpty) return [];

    Color? lastColor;
    return rawCategories.map((rawCategory) {
      final colorsPool = List<Color>.from(_colorsAvailable);
      if (lastColor != null && colorsPool.length > 1) colorsPool.remove(lastColor);

      final color = colorsPool[_rand.nextInt(colorsPool.length)];
      lastColor = color;

      final textColor = color == AppColors.primary || color == AppColors.accentOne ?
        AppColors.secondary :
        AppColors.primary;

      final hasBorder = _rand.nextBool();

      return Category.fromJson(rawCategory, color: color, hasBorder: hasBorder, textColor: textColor);
    }).toList();
  }
}