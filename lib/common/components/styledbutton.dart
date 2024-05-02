import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class StyledButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final double size;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;

  StyledButton({
    super.key,
    this.icon,
    this.text,
    this.size = 24,
    required this.buttonColor,
    this.textColor = Colors.black,
    required this.onPressed,
  })  : assert(icon != null || text != null,
            'At least one of icon or text must be provided'),
        assert(icon != null || text!.isNotEmpty,
            'Text must not be empty if icon is not provided'),
        assert(text != null || icon!.toString().isNotEmpty,
            'Icon must not be empty if text is not provided');

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            top: BorderSide(width: 2.0, color: Colors.black),
            left: BorderSide(width: 2.0, color: Colors.black),
            right: BorderSide(width: 2.0, color: Colors.black),
            bottom: BorderSide(width: 6.0, color: Colors.black),
          ),
          color: buttonColor),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(size / 6),
          child: icon != null
              ? FaIcon(
                  icon!,
                  size: size,
                  color: textColor,
                )
              : text != null
                  ? Text(
                      text!,
                      style: TextStyle(color: textColor),
                    )
                  : const Text(""),
        ),
      ),
    );
  }
}
