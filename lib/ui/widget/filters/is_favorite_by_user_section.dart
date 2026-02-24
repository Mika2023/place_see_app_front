import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/model/filters/is_favorite_by_user_enum.dart';

import 'filter_ratio_item.dart';

class IsFavoriteByUserSection extends StatelessWidget {
  final IsFavoriteByUserEnum selected;
  final ValueChanged<IsFavoriteByUserEnum> onChanged;

  const IsFavoriteByUserSection({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: IsFavoriteByUserEnum.values.map((val) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FilterRatioItem<IsFavoriteByUserEnum>(
              value: val,
              label: val.name,
              groupValue: selected,
              onChanged: onChanged
          ),
        );
      }).toList(),
    );
  }
}
