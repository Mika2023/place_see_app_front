import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/place/place_card.dart';
import 'package:place_see_app/features/main_screens/favorite_places/view_model/favorite_places_view_model.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_typography.dart';
import '../theme/placeholder_images.dart';
import 'auto_scrolling_text_widget.dart';

class PlaceWidget extends StatelessWidget {
  final PlaceCard placeCard;
  final VoidCallback? onTap;
  final VoidCallback? onFavTap;
  final double height;

  const PlaceWidget({
    super.key,
    required this.placeCard,
    this.onTap,
    this.onFavTap,
    this.height = 202
  });

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritePlacesViewModel>().hasFavoriteInList(placeCard.id);

    return PressableWidget(
        onPressed: onTap,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: placeCard.mainImageUrl ??
                      PlaceholderImages.pathToPlacePlaceholder,
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
                  top: 10,
                  right: 10,
                  child: PressableWidget(
                      onPressed: onFavTap,
                    child: ClipOval(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: Colors.black.withValues(alpha: 0.05),
                          child: isFav ? Assets.icons.heartSelected.svg(
                              width: 30,
                              height: 25
                          ) :
                          Assets.icons.heart.svg(
                              width: 30,
                              height: 25
                          ),
                        ),
                      ),
                    )
                  ),
                ),

                Positioned(
                    left: 12,
                    right: 11,
                    bottom: MediaQuery.of(context).size.width < 360 ? 13 : 12,
                    child: SizedBox(
                      height: 25,
                      child: AutoScrollingTextWidget(
                        text: placeCard.name,
                        style: AppTypography.textOnPicture,
                      ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}
