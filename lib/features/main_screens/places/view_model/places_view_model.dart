import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/model/filters/places_filters_state.dart';
import 'package:place_see_app/core/model/place/place_card.dart';
import 'package:place_see_app/features/main_screens/places/service/places_service.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';

class PlacesViewModel extends ChangeNotifier {
  PlacesService? _placesService;
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isFiltering = false;
  bool _isFilterMode = false;
  String? error;
  List<PlaceCard> _places = [];
  List<PlaceCard> _searchResults = [];
  List<PlaceCard> _filterResults = [];
  AppButtonState _currentState = AppButtonState.enabled;
  Timer? _debounce;
  final Map<String, List<PlaceCard>> _searchCache = {};
  String _query = '';
  List<String> suggestions = [];
  bool showSuggestions = false;
  PlacesFiltersState filtersState = PlacesFiltersState();

  void update(PlacesService service) {
    _placesService = service;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  bool get isFiltering => _isFiltering;
  bool get isFilterMode => _isFilterMode;
  List<PlaceCard> get places => _places;
  List<PlaceCard> get searchResults => _searchResults;
  List<PlaceCard> get filterResults => _filterResults;
  AppButtonState get currentState => _currentState;
  bool get isSearchMode => _query.isNotEmpty;

  Future<void> toggleFavorite(int index, {bool fromSearch = false}) async {
    if (index == -1) return;
    final placesList = fromSearch ? _searchResults : _places;
    final placeId = placesList[index].id;

    try {
      placesList[index] = placesList[index].copyWith(
        isFavorite: !(placesList[index].isFavorite ?? false),
      );
      await _placesService?.toggleFavorite(placeId);
    } catch (e) {
      error = e.toString();

      if (kDebugMode) print(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadPlaces(int catId) async {
    try {
      _isFilterMode = false;
      _isLoading = true;
      _currentState = AppButtonState.disabled;
      if (isSearchMode) _query = '';
      notifyListeners();

      _places = (await _placesService?.loadPlaces(catId))!;
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }

    } finally {
      _currentState = AppButtonState.enabled;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSearchChanged(String query) async {
    _query = query.trim();
    _debounce?.cancel();

    if (_query.length < 3) {
      suggestions = [];
      showSuggestions = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchPlaces(_query);
    });
  }

  void clearSearch() {
    _query = '';
    notifyListeners();
  }

  Future<void> searchPlaces(String query) async{
    _isFilterMode = false;
    if (_searchCache.containsKey(query)) {
      _searchResults = _searchCache[query]!;
      _updateSuggestions();
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      notifyListeners();

      final results = await _placesService!.searchPlaces(query);

      _searchResults = results;
      _searchCache[query] = results;

      _updateSuggestions();
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void _updateSuggestions() {
    suggestions = _searchResults.map((p) => p.name).toSet().take(6).toList();
    showSuggestions = suggestions.isNotEmpty;
  }

  void selectSuggestion(String suggestion, TextEditingController controller) {
    controller.text = suggestion;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
    );
    showSuggestions = false;
    searchPlaces(suggestion);
    notifyListeners();
  }

  Future<void> applyFilters(PlacesFiltersState newFilters) async {
    filtersState = newFilters;
    try {
      _isFiltering = true;
      _isFilterMode = true;
      _currentState = AppButtonState.disabled;
      notifyListeners();

      _filterResults = (await _placesService?.loadPlacesByFilters(filtersState))!;
    } catch (e) {
      error = e.toString();

      if(kDebugMode) {
        print(error);
      }

    } finally {
      _currentState = AppButtonState.enabled;
      _isSearching = false;
      notifyListeners();
    }
  }

  void resetFilters() {
    filtersState.reset();
    _isFilterMode = false;
    notifyListeners();
  }
}