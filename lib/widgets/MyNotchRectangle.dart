import 'package:flutter/material.dart';

class MyNotchedRectangle implements NotchedShape {
  const MyNotchedRectangle();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
   if (!host.overlaps(guest!)) return Path()..addRect(host);

    final double notchRadius = guest.width / 2;

    final double notchCenter = guest.center.dx;

    Path path = Path()
      ..moveTo(host.left, host.top)
      // Move to the left side of the notch
      ..lineTo(notchCenter - guest.width - 16, host.top)
      // Create the notch
      ..quadraticBezierTo(
        notchCenter - notchRadius - 12.0, host.top,
        notchCenter - notchRadius + 8, host.height / 3,
      )
      ..quadraticBezierTo(
        notchCenter, guest.bottom + 8.0,
        notchCenter + notchRadius - 15.0, host.height / 3 + 5,
      )
      // Move to the right side of the notch
      ..quadraticBezierTo(
        notchCenter + notchRadius + 12, host.top,
        notchCenter + guest.width + 16, host.top,
      )
      // ..quadraticBezierTo(
      //   notchCenter + notchRadius, host.height / 3,
      //   notchCenter + guest.width, host.top,
      // )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
    
    return path;
  }
}
