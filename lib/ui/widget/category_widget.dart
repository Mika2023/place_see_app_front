import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/category_short.dart';
import 'package:place_see_app/core/model/category/sub_category.dart';
import 'package:place_see_app/features/main_screens/places/screen/places_screen.dart';
import 'package:place_see_app/ui/widget/decoration/top_circular_border.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';
import 'package:place_see_app/ui/widget/sub_category_widget.dart';

import '../../core/model/category/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({super.key, required this.category});

  void _onTap(BuildContext context, int id, String name, String? description, Color? backColor, Color? textColor) {
    final catShort = CategoryShort(id, name, description, backColor, textColor);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>
            PlacesScreen(categoryShort: catShort)));
  }

  Widget _buildSubCats(BuildContext context, List<SubCategory> subCategories) {
    final length = subCategories.length;

    if (length == 1) {
      final subCat = subCategories.first;
      return SubCategoryWidget(
        subCategory: subCat,
        height: 230,
        onTap: () =>
            _onTap(context, subCat.id, subCat.name, subCat.description,
                category.color, category.textColor),
      );
    }

    if (length % 2 == 0) {
      return _buildGrid(context, subCategories, 2);
    }

    final firstSubCat = subCategories.first;

    return Column(
      children: [
        SubCategoryWidget(
          subCategory: firstSubCat,
          height: 230,
          onTap: () =>
              _onTap(context, firstSubCat.id, firstSubCat.name, firstSubCat.description,
                  category.color, category.textColor),
        ),

        const SizedBox(height: 16,),

        _buildGrid(context, subCategories.sublist(1), 2)
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<SubCategory> subCategories, int cols) {
    return GridView.builder(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1
        ),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCat = subCategories[index];
          return SubCategoryWidget(
            subCategory: subCat,
            onTap: () =>
                _onTap(context, subCat.id, subCat.name, subCat.description,
                    category.color, category.textColor),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = category.children;

    return Stack(
      children: [
        if (category.hasBorder && category.previousColor != null)
          Positioned.fill(
              child: Container(color: category.previousColor,)
          ),

        ClipPath(
          clipper: category.hasBorder ? TopCircularBorder() : null,
          child: Container(
            color: category.color,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PressableWidget(
                  onPressed: () =>
                      _onTap(context, category.id, category.name, category.description, category.color, category.textColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category.hasBorder)
                        SizedBox(height: 20,),

                      Text(
                        category.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: category.textColor,
                        ),
                      ),

                      if (category.description != null) ...[
                        const SizedBox(height: 12,),
                        Text(
                          category.description!,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: category.textColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16,),

                if (subCategories != null && subCategories.isNotEmpty)
                  _buildSubCats(context, subCategories)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
