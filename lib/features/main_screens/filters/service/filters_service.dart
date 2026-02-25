import '../../../../core/api/category_api.dart';
import '../../../../core/api/places_api.dart';
import '../../../../core/api/tag_api.dart';
import '../../../../core/model/category/category_for_filters.dart';
import '../../../../core/model/filters/transport_type_enum.dart';
import '../../../../core/model/tag/tag.dart';

class FiltersService {
  final PlacesApi placesApi;
  final TagApi tagApi;
  final CategoryApi categoryApi;

  FiltersService(this.placesApi, this.tagApi, this.categoryApi);

  Future<List<CategoryForFilters>> getCategoriesForFilters() async {
    final rawCats = await categoryApi.getAllCategoriesForFilters();

    if (rawCats.isEmpty) return [];

    return rawCats.map((rawCat) {
      return CategoryForFilters.fromJson(rawCat);
    }).toList();
  }

  Future<List<Tag>> getTagsForFilters() async {
    final rawTags = await tagApi.getAllTags();

    if (rawTags.isEmpty) return [];

    return rawTags.map((rawTag) {
      return Tag.fromJson(rawTag);
    }).toList();
  }

  Future<List<String>> getStationsByTransportTypeForFilters(TransportTypeEnum transportType) async {
    final stations = await placesApi.getAllStationsByTransportType(transportType.name);

    return stations;
  }
}