import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/place/place_card.dart';
import 'package:place_see_app/features/main_screens/place/view_model/place_view_model.dart';
import 'package:place_see_app/ui/widget/place_widget.dart';
import 'package:provider/provider.dart';

import '../place_screen.dart';

class PlacesNearby extends StatelessWidget {
  final List<PlaceCard>? places;

  const PlacesNearby({super.key, this.places});

  @override
  Widget build(BuildContext context) {
    final placesNearby = places ?? [];
    final vm = context.watch<PlaceViewModel>();

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: 8,),
        itemCount: placesNearby.length,
        itemBuilder: (_, i) {
          final place = placesNearby[i];

          return SizedBox(
            width: 350,
            child: PlaceWidget(
              placeCard: place,
              onTap: () => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>
                        PlaceScreen(id: place.id)))
              },
              onFavTap: () => vm.toggleFavorite(i),
            ),
          );
        },
      ),
    );
  }
}
