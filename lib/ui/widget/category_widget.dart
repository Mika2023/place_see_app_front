import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/category_short.dart';
import 'package:place_see_app/features/main_screens/places/screen/places_screen.dart';
import 'package:place_see_app/ui/widget/decoration/top_circular_border.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';
import 'package:place_see_app/ui/widget/sub_category_widget.dart';

import '../../core/model/category/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final subCategories = category.children;

    int cols;
    double aspectRatio = 1.2;

    if (subCategories!.length <= 2) {
      cols = subCategories.length;
    } else if (subCategories.length == 3) {
      cols = 2;
    } else {
      cols = 2;
    }

    return ClipPath(
      clipper: TopCircularBorder(),
      child: Container(
        color: category.color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PressableWidget(
              onPressed: () {
                final catShort = CategoryShort(category.id, category.name, category.description);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PlacesScreen(categoryShort: catShort)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: category.textColor,
                    ),
                  ),

                  if (category.description != null) ...[
                    const SizedBox(height: 16,),
                    Text(
                      category.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: category.textColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16,),

            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final subCat = subCategories[index];

                  double width = (index == 0 && subCategories.length >= 2) ? 2 : 1;

                  return SubCategoryWidget(
                      subCategory: subCat,
                    widthMultiplier: width,
                    onTap: () {
                      final catShort = CategoryShort(subCat.id, subCat.name, subCat.description);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PlacesScreen(categoryShort: catShort)));
                    },
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
