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

    return BottomAppBar(
      elevation: 0,
      padding: EdgeInsets.all(0),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: AppColors.primary,
          border: Border(
            top: BorderSide(
              color: AppColors.additionalTwo,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (i) {
            final isActive = currentIndex == i;
            return GestureDetector(
              onTap: () {
                final tappedTab = i >= navItems.length ? navItems[0].label : navItems[i].label;

                if (i == currentIndex) {
                  NavigatorInnerTabService.instance.popUntilRoot(context, tab: tappedTab);
                } else {
                  navProvider.setIndex(i);
                }
              },
              child: navItems[i].iconBuilder(isActive),
            );
          }),
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