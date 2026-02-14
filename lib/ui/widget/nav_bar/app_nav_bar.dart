import 'package:flutter/material.dart';
import 'package:place_see_app/ui/navigator/navigator_inner_tab_service.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/nav_bar/model/app_nav_item.dart';
import 'package:place_see_app/ui/widget/nav_bar/nav_bar_provider.dart';
import 'package:provider/provider.dart';

import '../../../gen/assets.gen.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.read<NavBarProvider>();
    final currentIndex = context.watch<NavBarProvider>().index;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        final tappedTab = i >= navItems.length ? navItems[0].label : navItems[i].label;

        if (i == currentIndex) {
          NavigatorInnerTabService.instance.popUntilRoot(context, tab: tappedTab);
        } else {
          navProvider.setIndex(i);
        }
      },
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.additionalTwo,
      items: List.generate(
          navItems.length,
          (i) => BottomNavigationBarItem(
            icon: navItems[i].iconBuilder(false),
            activeIcon: navItems[i].iconBuilder(true),
            label: navItems[i].label,
          ),
      ),
    );
  }
}

final List<AppNavItem> navItems = [
  AppNavItem(
      label: 'Home',
      iconBuilder: (selected) => Assets.icons.home.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
            selected? AppColors.secondary : AppColors.additionalTwo,
            BlendMode.srcIn,
        ),
      ),
  ),
  AppNavItem(
    label: 'Map',
    iconBuilder: (selected) => Assets.icons.compass.svg(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        selected? AppColors.secondary : AppColors.additionalTwo,
        BlendMode.srcIn,
      ),
    ),
  ),
  AppNavItem(
    label: 'Favorites',
    iconBuilder: (selected) => Assets.icons.heart.svg(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        selected? AppColors.secondary : AppColors.additionalTwo,
        BlendMode.srcIn,
      ),
    ),
  ),
  AppNavItem(
    label: 'Profile',
    iconBuilder: (selected) => Assets.icons.menu.svg(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        selected? AppColors.secondary : AppColors.additionalTwo,
        BlendMode.srcIn,
      ),
    ),
  ),
];