import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/categories/screen/categories_screen.dart';
import 'package:place_see_app/features/main_screens/favorite_places/screen/favorite_places_screen.dart';
import 'package:place_see_app/features/main_screens/maps/screen/maps_screen.dart';
import 'package:place_see_app/features/main_screens/profile/screen/profile_screen.dart';
import 'package:place_see_app/ui/navigator/navigator_inner_tab_service.dart';
import 'package:place_see_app/ui/widget/nav_bar/app_nav_bar.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:place_see_app/ui/widget/nav_bar/tab_navigator.dart';
import 'package:provider/provider.dart';

class MainScaffoldWithNavBar extends StatefulWidget {
  const MainScaffoldWithNavBar({super.key});

  @override
  State<MainScaffoldWithNavBar> createState() => _MainScaffoldWithNavBarState();
}

class _MainScaffoldWithNavBarState extends State<MainScaffoldWithNavBar> {
  final _navigatorKeys = List.generate(
      navItems.length, 
      (_) => GlobalKey<NavigatorState>()
  );

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < navItems.length; i++) {
      NavigatorInnerTabService.instance.registerTab(navItems[i].label, _navigatorKeys[i]);
    }
  }
  
  Future<bool> _handlePop() async {
    final navProvider = context.read<NavBarProvider>();
    final currentNavigator = _navigatorKeys[navProvider.index].currentState!;
    
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    final index = context.watch<NavBarProvider>().index;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldClose = await _handlePop();
          if(shouldClose && mounted) {
            Navigator.of(context).maybePop();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: index,
            children: [
              TabNavigator(
                  navigatorKey: _navigatorKeys[0],
                  rootScreen: const CategoriesScreen(),
              ),
              TabNavigator(
                navigatorKey: _navigatorKeys[1],
                rootScreen: const MapsScreen(),
              ),
              TabNavigator(
                navigatorKey: _navigatorKeys[2],
                rootScreen: const FavoritePlacesScreen(),
              ),
              TabNavigator(
                navigatorKey: _navigatorKeys[3],
                rootScreen: const ProfileScreen(),
              ),
            ],
          ),
          bottomNavigationBar: const AppNavBar(),
        ),
    );
  }
}

