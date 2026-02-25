class CategoryForFilters {
  final int id;
  final String name;

  const CategoryForFilters(this.id, this.name);

  factory CategoryForFilters.fromJson(Map<String, dynamic> json) {
    return CategoryForFilters(
        json['id'],
        json['name'],
    );
  }
}