import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/features/main_screens/place/screen/widgets/place_main_photos_gallery.dart';
import 'package:place_see_app/ui/widget/back_button.dart';

class PlaceHeader extends StatelessWidget {
  final List<PhotoFullInfo> photos;

  const PlaceHeader({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlaceMainPhotosGallery(photos: photos),

        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
            left: 17,
            child: BackButton(),
        )
      ],
    );
  }
}
