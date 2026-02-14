import 'package:flutter/cupertino.dart';
import 'package:place_see_app/ui/widget/nav_bar/app_nav_bar.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';

class NavigatorInnerTabService {
  NavigatorInnerTabService._privateConstructor();
  static final instance = NavigatorInnerTabService._privateConstructor();

  final Map<String, GlobalKey<NavigatorState>> navigatorKeys = {};

  void registerTab(String tab, GlobalKey<NavigatorState> key) {
    navigatorKeys[tab] = key;
  }

  NavigatorState? _getNavigator(String? tab) {
    if (tab != null && navigatorKeys.containsKey(tab)) {
      return navigatorKeys[tab]!.currentState;
    }
    return null;
  }

  Future<T?> push<T>(BuildContext context, Route<T> route, {String? tab}) {
    final activeTab = tab ?? _getCurrentTab(context);
    final nav = _getNavigator(activeTab);
    if (nav != null) {
      return nav.push(route);
    }
    throw Exception("Навигации для $tab не существует");
  }

  void pop<T extends Object?>(BuildContext context, {String? tab, T? returnResult}) {
    final activeTab = tab ?? _getCurrentTab(context);
    final nav = _getNavigator(activeTab);
    if (nav != null && nav.canPop()) {
      nav.pop(returnResult);
    }
  }

  void popUntilRoot(BuildContext context, {String? tab}) {
    final activeTab = tab ?? _getCurrentTab(context);
    final nav = _getNavigator(activeTab);
    if (nav != null) {
      nav.popUntil((route) => route.isFirst);
    }
  }

  String _getCurrentTab(BuildContext context) {
    final index = context.read<NavBarProvider>().index;
    return index >= navItems.length ? navItems[0].label : navItems[index].label;
  }
}