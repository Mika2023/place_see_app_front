import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/loadable/load_status_enum.dart';
import 'package:place_see_app/core/loadable/loadable.dart';
import 'package:place_see_app/features/main_screens/filters/service/filters_service.dart';

import '../../../../core/model/category/category_for_filters.dart';
import '../../../../core/model/filters/transport_type_enum.dart';
import '../../../../core/model/tag/tag.dart';

class FiltersViewModel extends ChangeNotifier {
  FiltersService? _filtersService;
  Loadable<List<Tag>> _tagsForFilters = Loadable.loading(tagsDefault);
  Loadable<List<CategoryForFilters>> _categoriesForFilters = Loadable.loading(categoriesDefault);
  Loadable<List<String>> _stationsForFilters = Loadable.loading(metroStationsDefault);
  String? error;
  Map<int, String> _categoriesForSelectedText = {};
  Map<int, String> _tagsForSelectedText = {};
  bool _isPreloaded = false;

  void update(FiltersService service) {
    _filtersService = service;
    notifyListeners();
  }

  List<Tag> get tagsForFilters => _tagsForFilters.data;
  List<CategoryForFilters> get categoriesForFilters => _categoriesForFilters.data;
  List<String> get stationsForFilters => _stationsForFilters.data;
  LoadStatusEnum get tagsForFiltersState => _tagsForFilters.loadStatus;
  LoadStatusEnum get categoriesForFiltersState => _categoriesForFilters.loadStatus;
  LoadStatusEnum get stationsForFiltersState => _stationsForFilters.loadStatus;

  void _parseCategoriesToMap(List<CategoryForFilters> categories) {
    for (var category in categories) {
      _categoriesForSelectedText[category.id] = category.name;
    }
  }

  void _parseTagsToMap(List<Tag> tags) {
    for (var tag in tags) {
      _tagsForSelectedText[tag.id] = tag.name;
    }
  }

  String getStringForCategories(Set<int> categoryIds) {
    return categoryIds.map((id) => _categoriesForSelectedText[id]).join(', ');
  }

  String getStringForTags(Set<int> tagIds) {
    return tagIds.map((id) => _tagsForSelectedText[id]).join(', ');
  }

  Future<void> preloadAll() async {
    if (_isPreloaded) return;

    _isPreloaded = true;

    await Future.wait([
      initializeFiltersTags(),
      initializeFiltersStations(TransportTypeEnum.metro),
      initializeFiltersCategories()
    ]);
  }

  Future<void> initializeFiltersCategories() async {
    try {
      _categoriesForFilters = Loadable.loading(_categoriesForFilters.data);
      notifyListeners();

      final result = (await _filtersService?.getCategoriesForFilters())!;

      _categoriesForFilters = result.isEmpty ? Loadable.error(categoriesDefault) : Loadable.success(result);
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }

      _categoriesForFilters = Loadable.error(categoriesDefault);

    } finally {
      _parseCategoriesToMap(_categoriesForFilters.data);
      notifyListeners();
    }
  }

  Future<void> initializeFiltersTags() async {
    try {
      _tagsForFilters = Loadable.loading(_tagsForFilters.data);
      notifyListeners();

      final result = (await _filtersService?.getTagsForFilters())!;

      _tagsForFilters = result.isEmpty ? Loadable.error(tagsDefault) : Loadable.success(result);
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }

      _tagsForFilters = Loadable.error(tagsDefault);

    } finally {
      _parseTagsToMap(_tagsForFilters.data);
      notifyListeners();
    }
  }

  Future<void> initializeFiltersStations(TransportTypeEnum transportType) async {
    try {
      _stationsForFilters = Loadable.loading(_stationsForFilters.data);
      notifyListeners();

      final result = (await _filtersService?.getStationsByTransportTypeForFilters(transportType))!;

      _stationsForFilters = result.isEmpty ? Loadable.error(metroStationsDefault) : Loadable.success(result);
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }

      _stationsForFilters = Loadable.error(metroStationsDefault);

    } finally {
      notifyListeners();
    }
  }
}

final List<CategoryForFilters> categoriesDefault = [
  CategoryForFilters(1, 'Азия'),
  CategoryForFilters(2, 'Европа'),
  CategoryForFilters(3, 'Москва'),
];

final List<Tag> tagsDefault = [
  Tag(1, 'Популярное'),
  Tag(2, 'Азия'),
  Tag(3, 'Музеи'),
];

final List<String> metroStationsDefault = [
  "ВДНХ",
  "Ботанический сад",
  "Рижская",
];
