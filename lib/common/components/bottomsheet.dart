import 'package:flutter/material.dart';
import 'package:kromenote_flutter/common/components/blockshadowborder.dart';

Container bottomSheet(Widget content) {
  return Container(
      decoration:
          BoxDecoration(border: blockShadowBorder(6.0), color: Colors.white),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: content);
}
