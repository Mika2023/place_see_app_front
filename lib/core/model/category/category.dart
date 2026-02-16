import 'package:flutter/material.dart';
import 'package:place_see_app/core/model/category/sub_category.dart';

class Category {
  final int id;
  final String name;
  String? description;
  String? imageUrl;
  List<SubCategory>? children;
  final bool hasBorder;
  final Color color;
  final Color textColor;
  final Color? previousColor;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.children,
    required this.color,
    required this.hasBorder,
    required this.textColor,
    this.previousColor
  });

  factory Category.fromJson(
      Map<String, dynamic> json,
      {required Color color, required bool hasBorder, required Color textColor, Color? prevColor}
  ) {
    final subCatsJson = json['children'] as List<dynamic>?;
    final subCats = subCatsJson?.map((el) => SubCategory.fromJson(el)).toList();

    return Category(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        children: subCats,
        color: color,
        hasBorder: hasBorder,
        textColor: textColor,
        previousColor: prevColor
    );
  }
}