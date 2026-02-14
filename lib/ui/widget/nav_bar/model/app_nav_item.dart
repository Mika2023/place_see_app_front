import 'package:flutter/cupertino.dart';

class AppNavItem {
  final String label;
  final Widget Function(bool selected) iconBuilder;

  const AppNavItem({
    required this.label,
    required this.iconBuilder,
  });
}