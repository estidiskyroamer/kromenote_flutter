import 'package:flutter/material.dart';

Border blockShadowBorder(double shadow, {Color color = Colors.black}) {
  return Border(
    top: BorderSide(width: 2.0, color: color),
    left: BorderSide(width: 2.0, color: color),
    right: BorderSide(width: 2.0, color: color),
    bottom: BorderSide(width: shadow, color: color),
  );
}
