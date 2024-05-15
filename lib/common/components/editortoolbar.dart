import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/blockshadowborder.dart';

Container editorToolbar(FleatherController controller, String color) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: blockShadowBorder(6.0),
      color: HexColor(color),
    ),
    child: Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        ToggleStyleButton(
          attribute: ParchmentAttribute.bold,
          icon: FontAwesomeIcons.bold,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.italic,
          icon: FontAwesomeIcons.italic,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.underline,
          icon: FontAwesomeIcons.underline,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.strikethrough,
          icon: FontAwesomeIcons.strikethrough,
          controller: controller,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.left,
          icon: FontAwesomeIcons.alignLeft,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.right,
          icon: FontAwesomeIcons.alignRight,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.center,
          icon: FontAwesomeIcons.alignCenter,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.justify,
          icon: FontAwesomeIcons.alignJustify,
          controller: controller,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.ol,
          icon: FontAwesomeIcons.listOl,
          controller: controller,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.ul,
          icon: FontAwesomeIcons.listUl,
          controller: controller,
        ),
      ],
    ),
  );
}
