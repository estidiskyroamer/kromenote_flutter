import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

Container styledTextField(TextEditingController textController, String hintText,
    {bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    double fontSize = 16}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    decoration: const BoxDecoration(
      border: DashedBorder(
          dashLength: 6, bottom: BorderSide(width: 1.5, color: Colors.black)),
    ),
    child: TextField(
      obscureText: isPassword,
      keyboardType: inputType,
      controller: textController,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(hintText: hintText, border: InputBorder.none),
    ),
  );
}
