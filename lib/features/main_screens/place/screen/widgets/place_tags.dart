import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

class PlaceTags extends StatelessWidget {
  final List<String> tags;

  const PlaceTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          separatorBuilder: (_, _) => const SizedBox(width: 8,),
          itemCount: tags.length,
        itemBuilder: (_, i) {
          final tag = tags[i];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: AppColors.secondary,
                  ),
                  borderRadius: BorderRadius.circular(22)
                )
            ),
            child: Text(
              tag,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
        },
      ),
    );
  }
}
