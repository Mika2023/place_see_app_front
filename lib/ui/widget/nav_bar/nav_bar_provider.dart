import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/api/system_events_api.dart';
import 'package:place_see_app/core/model/system_event_names_enum.dart';

class NavBarProvider extends ChangeNotifier{
  SystemEventsApi? systemEventsApi;

  void update(SystemEventsApi api) {
    systemEventsApi = api;
  }

  int _index = 0;

  int get index => _index;

  void setIndex(int newInd) {
    if (newInd == _index) return;
    _index = newInd;

    if (navBarItemsToEventNames.containsKey(newInd) && navBarItemsToEventNames[newInd] != null) {
      systemEventsApi?.createEvent(navBarItemsToEventNames[newInd]!);
    }

    notifyListeners();
  }
}

/// Мапа для присваивания имени события к id экрана из навигации (список AppNavItem)
final Map<int, SystemEventNamesEnum> navBarItemsToEventNames = {
  0: SystemEventNamesEnum.visitedMainScreen,
  1: SystemEventNamesEnum.visitedRoutesScreen
};