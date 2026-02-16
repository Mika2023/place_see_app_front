import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/sub_category.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';
import 'package:place_see_app/ui/widget/auto_scrolling_text_widget.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

class SubCategoryWidget extends StatelessWidget {
  final SubCategory subCategory;
  final double widthMultiplier;
  final VoidCallback? onTap;

  const SubCategoryWidget({
    super.key,
    required this.subCategory,
    this.widthMultiplier = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
      onPressed: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * widthMultiplier;

          return SizedBox(
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: subCategory.imageUrl ?? 'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 50,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.6)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter
                              )
                          )
                      )
                  ),

                  Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: SizedBox(
                        height: 25,
                        child: AutoScrollingTextWidget(
                          text: subCategory.name,
                          style: AppTypography.textOnPicture,
                        ),
                      )
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
