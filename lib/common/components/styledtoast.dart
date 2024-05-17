import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/blockshadowborder.dart';
import 'package:toastification/toastification.dart';

ToastificationItem styledToast(ToastificationType type, String content) {
  switch (type) {
    case ToastificationType.error:
      return toastification.showCustom(
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
        builder: (context, holder) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: blockShadowBorder(8.0), color: HexColor("#ff6e6e")),
            child: Text(content),
          );
        },
      );
    case ToastificationType.warning:
      return toastification.showCustom(
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
        builder: (context, holder) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: blockShadowBorder(8.0), color: HexColor("#ffc93f")),
            child: Text(content),
          );
        },
      );
    case ToastificationType.success:
      return toastification.showCustom(
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
        builder: (context, holder) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: blockShadowBorder(8.0), color: HexColor("#70ff6e")),
            child: Text(content),
          );
        },
      );
    case ToastificationType.info:
      return toastification.showCustom(
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
        builder: (context, holder) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: blockShadowBorder(8.0), color: HexColor("#6eb9ff")),
            child: Text(content),
          );
        },
      );
    default:
      return toastification.showCustom(
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
        builder: (context, holder) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: blockShadowBorder(8.0), color: HexColor("#6eb9ff")),
            child: Text(content),
          );
        },
      );
  }
}
