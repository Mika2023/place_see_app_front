import 'package:place_see_app/core/model/filters/filters_model.dart';
import 'package:place_see_app/core/model/filters/is_favorite_by_user_enum.dart';
import 'package:place_see_app/core/model/filters/price_filter.dart';
import 'package:place_see_app/core/model/filters/sort_enum.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';
import 'package:place_see_app/core/model/filters/working_hours_state.dart';

class PlacesFiltersState {
  PriceFilter priceFilter = PriceFilter();
  Set<int> categoryIds = {};
  Map<TransportTypeEnum, Set<String>> selectedStops = {};
  WorkingHoursState workingHoursState = WorkingHoursState();
  IsFavoriteByUserEnum isFavoriteByUserState = IsFavoriteByUserEnum.any;

  SortEnum sort = SortEnum.defaultSort;
  int page = 0;
  int size = 20;

  void reset() {
    priceFilter = priceFilter.reset();
    categoryIds = {};
    selectedStops = {};
    workingHoursState.reset();
    isFavoriteByUserState = IsFavoriteByUserEnum.any;
    sort = SortEnum.defaultSort;
    page = 0;
    size = 20;
  }

  FiltersModel toDto() {
    return FiltersModel(
      minPrice: priceFilter.minPrice,
      maxPrice: priceFilter.maxPrice,
      categoryIds: categoryIds.isEmpty ? null : categoryIds,
      selectedStops: selectedStops.map((key, val) => MapEntry(key.name, val)),
      isFavoriteByUser: isFavoriteByUserState.isFavorite,
      workingHoursFilter: workingHoursState.toDto(),
      sort: sort.name,
      page: page,
      size: size
    );
  }
}