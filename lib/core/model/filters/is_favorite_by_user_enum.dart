enum IsFavoriteByUserEnum {
  any(null, 'Все'),
  onlyFavorite(true, 'Только избранные');

  final bool? isFavorite;
  final String name;

  const IsFavoriteByUserEnum(this.isFavorite, this.name);
}