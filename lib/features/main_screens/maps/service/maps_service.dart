import 'package:place_see_app/core/api/places_api.dart';
import 'package:place_see_app/core/api/route_api.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/core/model/routes/route_model.dart';
import 'package:place_see_app/core/model/routes/route_transport_type_enum.dart';

class MapsService {
  final RouteApi routeApi;
  final PlacesApi placesApi;

  MapsService(this.routeApi, this.placesApi);

  Future<RouteModel> createAndGetRoute(int toPlaceId, RouteTransportTypeEnum transportType) async {
    final rawRoute = await routeApi.createAndGetRoute(toPlaceId, transportType);

    if (rawRoute.isEmpty) throw Exception('Ответ от апи пришел пустой!');

    return RouteModel.fromJson(rawRoute);
  }

  Future<RouteModel> editRoute(int? fromPlaceId, int? toPlaceId, int routeId, RouteTransportTypeEnum transportType) async {
    final rawRoute = await routeApi.editRoute(fromPlaceId, toPlaceId, routeId, transportType);

    if (rawRoute.isEmpty) throw Exception('Ответ от апи пришел пустой!');

    return RouteModel.fromJson(rawRoute);
  }

  Future<List<PlaceShortForSearch>> getPlacesForSearch() async {
    final rawPlaces = await placesApi.getPlacesForSearch();

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((place) => PlaceShortForSearch.fromJson(place)).toList();
  }
}