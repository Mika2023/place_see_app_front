class PriceFilter {
  final double? minPrice;
  final double? maxPrice;

  const PriceFilter({this.minPrice, this.maxPrice});
  
  PriceFilter copyWith({double? min, double? max}) {
    return PriceFilter(
        minPrice: min ?? minPrice,
        maxPrice: max ?? maxPrice,
    );
  }

  PriceFilter reset() {
    return PriceFilter(
      minPrice: null,
      maxPrice: null,
    );
  }
  
  bool get isEmpty => minPrice == null && maxPrice == null;
  
  String get label {
    if (minPrice == null && maxPrice == null) return 'Любая';

    if (minPrice == 0 && maxPrice == 0) return 'Бесплатно';

    if (maxPrice != null && minPrice != null) {
      return '${minPrice!.toInt()} - ${maxPrice!.toInt()} ₽';
    }

    if (minPrice != null) return 'от ${minPrice!.toInt()} ₽';
    return 'до ${maxPrice!.toInt()} ₽';
  }
}