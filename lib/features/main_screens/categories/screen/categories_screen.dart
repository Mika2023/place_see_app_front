import 'package:flutter/material.dart';
import 'package:place_see_app/features/main_screens/categories/view_model/categories_view_model.dart';
import 'package:place_see_app/ui/widget/category_widget.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';

class CategoriesScreen extends StatelessWidget{

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoriesViewModel>();

    if (vm.isLoading) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 135),

              Assets.icons.timeClock.svg(
                width: 150,
                height: 150,
              ),

              const SizedBox(height: 40,),

              Text(
                'Сейчас появятся интересные категории...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (vm.categories.isEmpty) {
      vm.loadCategories();
      return SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 135),

              Assets.icons.timeClock.svg(
                width: 150,
                height: 150,
              ),

              const SizedBox(height: 40,),

              Text(
                'Сейчас появятся интересные категории...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: vm.categories.map((cat) => CategoryWidget(category: cat)).toList(),
      ),
    );
  }
}