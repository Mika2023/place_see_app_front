import 'dart:math';

import 'package:flutter/cupertino.dart';

class TopCircularBorder extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const diameter = 48.75;
    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, diameter);

    double x = 0;
    while (x < size.width) {
      path.arcTo(
          Rect.fromLTWH(x, 0, diameter, diameter),
          pi,
          -pi,
          false
      );
      x += diameter;
    }

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
