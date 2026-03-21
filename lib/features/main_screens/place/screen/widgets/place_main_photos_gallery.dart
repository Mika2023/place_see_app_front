import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

import '../../../../../ui/theme/placeholder_images.dart';

class PlaceMainPhotosGallery extends StatefulWidget {
  final List<PhotoFullInfo> photos;

  const PlaceMainPhotosGallery({super.key, required this.photos});

  @override
  State<PlaceMainPhotosGallery> createState() => _PlaceMainPhotosGalleryState();
}

class _PlaceMainPhotosGalleryState extends State<PlaceMainPhotosGallery> {
  final controller = PageController();
  int page = 0;

  @override
  Widget build(BuildContext context) {


    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (widget.photos.isEmpty)
          CachedNetworkImage(
            imageUrl: PlaceholderImages.pathToPlacePlaceholder,
            fit: BoxFit.cover,
          ),

        SizedBox(
          height: 330,
          child: PageView.builder(
            controller: controller,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => page = i),
              itemBuilder: (_, i) =>
                  CachedNetworkImage(
                    imageUrl: widget.photos[i].imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        if (widget.photos.length > 1)
          Positioned(
            bottom: 32,
            child: Row(
              children: List.generate(widget.photos.length, (i) {
                final selected = i == page;
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: selected ? 17 : 11,
                  height: selected ? 17 : 11,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accentOne : AppColors.disabledLight,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          )
      ],
    );
  }
}
