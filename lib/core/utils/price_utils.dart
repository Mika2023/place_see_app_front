import 'package:place_see_app/core/model/filters/price_filter.dart';
import 'package:place_see_app/ui/widget/filters/price_preset_section.dart';

class PriceUtils {
  static PricePreset presetFromFilter(PriceFilter filter) {
    return PricePreset.values.firstWhere((preset) {
      return preset.priceFilter.minPrice == filter.minPrice && preset.priceFilter.maxPrice == filter.maxPrice;
    }, orElse: () => PricePreset.any);
  }
}