import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

Container editorToolbar(FleatherController _controller) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: const Border(
        top: BorderSide(width: 2.0, color: Colors.black),
        left: BorderSide(width: 2.0, color: Colors.black),
        right: BorderSide(width: 2.0, color: Colors.black),
        bottom: BorderSide(width: 4.0, color: Colors.black),
      ),
      color: HexColor("#6eb9ff"),
    ),
    child: Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        ToggleStyleButton(
          attribute: ParchmentAttribute.bold,
          icon: FontAwesomeIcons.bold,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.italic,
          icon: FontAwesomeIcons.italic,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.underline,
          icon: FontAwesomeIcons.underline,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.strikethrough,
          icon: FontAwesomeIcons.strikethrough,
          controller: _controller,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.left,
          icon: FontAwesomeIcons.alignLeft,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.right,
          icon: FontAwesomeIcons.alignRight,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.center,
          icon: FontAwesomeIcons.alignCenter,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.justify,
          icon: FontAwesomeIcons.alignJustify,
          controller: _controller,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.ol,
          icon: FontAwesomeIcons.listOl,
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.ul,
          icon: FontAwesomeIcons.listUl,
          controller: _controller,
        ),
      ],
    ),
  );
}
