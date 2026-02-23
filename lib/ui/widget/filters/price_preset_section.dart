import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/model/filters/price_filter.dart';
import 'package:place_see_app/ui/widget/filters/filter_ratio_item.dart';

enum PricePreset {
  any('Любая', PriceFilter()),
  free('Бесплатно', PriceFilter(minPrice: 0, maxPrice: 0)),
  under500('До 500₽', PriceFilter(maxPrice: 500)),
  between500and1000('500-1000₽', PriceFilter(minPrice: 500, maxPrice: 1000)),
  between1000and1500('1000-1500₽', PriceFilter(minPrice: 1000, maxPrice: 1500)),
  between1500and2000('1500-2000₽', PriceFilter(minPrice: 1500, maxPrice: 2000)),
  above2000('От 2000₽', PriceFilter(minPrice: 2000));

  final String label;
  final PriceFilter priceFilter;

  const PricePreset(this.label, this.priceFilter);
}

class PricePresetSection extends StatelessWidget {
  final PricePreset selected;
  final ValueChanged<PricePreset> onChanged;

  const PricePresetSection({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PricePreset.values.map((preset) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
          child: FilterRatioItem<PricePreset>(
              value: preset,
              label: preset.label,
              groupValue: selected,
              onChanged: onChanged
          ),
        );
      }).toList(),
    );
  }
}
