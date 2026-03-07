import 'package:flutter/cupertino.dart';

class MapDataProvider extends ChangeNotifier{
  int? placeId;
  String? placeName;

  void setPlace(int id, String name) {
    placeId = id;
    placeName = name;
    notifyListeners();
  }

  void nullPlace() {
    placeId = null;
    placeName = null;
  }
}