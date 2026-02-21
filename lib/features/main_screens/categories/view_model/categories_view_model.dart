import 'package:flutter/foundation.dart' hide Category;
import 'package:place_see_app/core/model/category/category.dart';
import 'package:place_see_app/features/main_screens/categories/service/category_service.dart';

enum CategoriesState {
  initial,
  loading,
  loaded,
  error
}

class CategoriesViewModel extends ChangeNotifier{
  CategoryService? _categoryService;
  bool _isLoading = false;
  List<Category> _categories = [];
  CategoriesState state = CategoriesState.initial;

  void update(CategoryService service) {
    _categoryService = service;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {

    try {
      _isLoading = true;
      state = CategoriesState.loading;
      notifyListeners();

      _categories = (await _categoryService?.loadCategories())!;
      state = CategoriesState.loaded;
    } catch (e) {
      final error = e.toString();

       if(kDebugMode) {
         print(error);
       }

       state = CategoriesState.error;

    } finally {
      notifyListeners();
    }
  }
}