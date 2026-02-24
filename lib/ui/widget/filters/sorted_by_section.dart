import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/model/filters/sort_enum.dart';

import 'filter_ratio_item.dart';

class SortedBySection extends StatelessWidget {
  final SortEnum selected;
  final ValueChanged<SortEnum> onChanged;

  const SortedBySection({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: SortEnum.values.map((sort) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FilterRatioItem<SortEnum>(
              value: sort,
              label: sort.subName,
              groupValue: selected,
              onChanged: onChanged
          ),
        );
      }).toList(),
    );
  }
}
