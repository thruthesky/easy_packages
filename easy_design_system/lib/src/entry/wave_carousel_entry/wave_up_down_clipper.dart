import 'package:flutter/material.dart';

class WaveUpDownClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint1 = Offset(150, size.height - 200);
    var controlPoint2 = Offset(size.width - 250, size.height);
    var endPoint = Offset(size.width, size.height - 0);

    Path path = Path()
      // ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height - 100)
      ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
