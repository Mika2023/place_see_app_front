enum SortEnum {
  defaultSort("По умолчанию", "По умолчанию"),
  newest("Новизна", "Новизне"),
  priceAsc("Возрастание цены", "Возрастанию цены"),
  priceDesc("Убывание цены", "Убыванию цены"),
  popularity("Популярность", "Популярности"),
  closest("Близость", "Близости");

  final String name;
  final String subName;
  const SortEnum(this.name, this.subName);
}