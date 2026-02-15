import 'dart:ffi';

class SubCategory {
  final Long id;
  final String name;
  final Long parentId;
  String? imageUrl;
  String? description;

  SubCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.parentId,
    this.description,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
        id: json['id'],
        name: json['name'],
        parentId: json['parentId'],
        imageUrl: json['imageUrl'],
        description: json['description'],
    );
  }
}