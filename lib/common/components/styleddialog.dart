import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/blockshadowborder.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';

enum DialogType { info, warning, update }

class StyledDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  Widget? content;
  final String actionText;
  final String cancelText;
  String? dialogText;
  final VoidCallback cancelCallback;
  final VoidCallback actionCallback;

  StyledDialog(
      {super.key,
      required this.type,
      required this.title,
      this.content,
      required this.actionText,
      required this.cancelText,
      this.dialogText,
      required this.cancelCallback,
      required this.actionCallback});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    switch (type) {
      case DialogType.info:
        color = HexColor('#a8d5ff');
        break;
      case DialogType.update:
        color = HexColor('#a9ffa8');
        break;
      case DialogType.warning:
        color = HexColor('#ffa8a8');
        break;
      default:
    }
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: blockShadowBorder(6.0),
      actions: [
        TextButton(onPressed: cancelCallback, child: Text(cancelText)),
        StyledButton(
            buttonColor: color, onPressed: actionCallback, text: actionText),
      ],
      content: content ?? Text(dialogText!),
      title: Text(title),
    );
  }
}
