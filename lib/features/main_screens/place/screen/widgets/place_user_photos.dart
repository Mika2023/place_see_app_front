import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/ui/widget/photo_gallery_screen.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

class PlaceUserPhotos extends StatelessWidget {
  final List<PhotoFullInfo> photos;

  const PlaceUserPhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          separatorBuilder: (_, _) => const SizedBox(width: 8,),
          itemCount: photos.length,
        itemBuilder: (_, i) {
          final photo = photos[i];
          return PressableWidget(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                  pageBuilder: (_, _, _) => PhotoGalleryScreen(
                      photos: photos,
                      initialIndex: i
                  )
              )
            ),
              child: Hero(
                tag: photo.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: photo.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )
              ),
          );
        },
      ),
    );
  }
}
