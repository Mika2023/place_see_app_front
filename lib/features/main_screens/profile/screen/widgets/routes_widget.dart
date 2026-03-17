import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/model/routes/route_profile_info.dart';
import '../../../../../ui/widget/stateful/pressable_widget.dart';

class RoutesWidget extends StatelessWidget {
  final List<RouteProfileInfo> routes;
  final String? Function(int index) buildUrl;
  final void Function(int routeId) onPressedRoute;

  const RoutesWidget({super.key, required this.routes, required this.buildUrl, required this.onPressedRoute});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: 8,),
        itemCount: routes.length,
        itemBuilder: (_, i) {
          final route = routes[i];
          final url = buildUrl(i);

          return PressableWidget(
            onPressed: () => onPressedRoute(route.id),
            child: Hero(
                tag: url ?? 'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: url ?? 'https://lqtiftmgexxmtoohvldc.supabase.co/storage/v1/object/public/place_photos/b1cc9987043f82eda1963ab8ba5d03c5%20(1).jpg',
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
