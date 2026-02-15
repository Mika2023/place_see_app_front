import 'package:flutter/foundation.dart' hide Category;
import 'package:place_see_app/core/model/category/category.dart';
import 'package:place_see_app/features/main_screens/categories/service/category_service.dart';

class CategoriesViewModel extends ChangeNotifier{
  CategoryService? _categoryService;
  bool _isLoading = false;
  String? error;
  List<Category> _categories = [];

  void update(CategoryService service) {
    _categoryService = service;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      _categories = (await _categoryService?.loadCategories())!;
    } catch (e) {
      error = e.toString();

       if(kDebugMode) {
         print(error);
       }

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}