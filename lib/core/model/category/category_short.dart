import 'package:flutter/cupertino.dart';

class CategoryShort {
  final int id;
  final String name;
  String? description;
  Color? backColor;
  Color? textColor;

  CategoryShort(this.id, this.name, this.description, this.backColor, this.textColor);
}