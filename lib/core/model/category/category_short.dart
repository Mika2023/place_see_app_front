import 'dart:ffi';

class CategoryShort {
  final Long id;
  final String name;
  String? description;

  CategoryShort(this.id, this.name, this.description);
}