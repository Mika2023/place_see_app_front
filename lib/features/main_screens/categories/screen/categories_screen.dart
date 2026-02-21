import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/categories/view_model/categories_view_model.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/placeholder_with_icon_widget.dart';
import 'package:place_see_app/ui/widget/category_widget.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesViewModel>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoriesViewModel>();

    switch(vm.state) {
      case CategoriesState.initial:
      case CategoriesState.loading:
        return SafeArea(
          child: PlaceholderWithIconWidget(
            icon: Assets.icons.timeClock.svg(
              width: 82,
              height: 82,
            ),
            text: 'Сейчас появятся интересные категории...',
            padding: const EdgeInsets.symmetric(horizontal: 22),
          ),
        );
      case CategoriesState.error:
        return SafeArea(
            child: PlaceholderWithIconWidget(
              icon: Assets.icons.noData.svg(
                  width: 82,
                  height: 82
              ),
              text: 'Упс! Кажется, произошла ошибка\nПроверьте подключение к Интернету или обратитесь в поддержку',
              padding: const EdgeInsets.symmetric(horizontal: 22),
            )
        );
      case CategoriesState.loaded:
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: vm.categories.isNotEmpty ? vm.categories.first.color : AppColors.primary,
                child: SafeArea(
                  child: Column(
                    children: vm.categories.map((cat) => CategoryWidget(category: cat)).toList(),
                  ),
                ),
              )
            ],
          ),
        );
    }
  }
}