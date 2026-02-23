enum SortEnum {
  newest("Новизна"),
  priceAsc("Возрастание цены"),
  priceDesc("Убывание цены"),
  popularity("Популярность"),
  closest("Близость"),
  defaultSort("По умолчанию");

  final String name;
  const SortEnum(this.name);
}