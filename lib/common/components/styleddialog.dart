import 'package:flutter/material.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';

class StyledDialog extends StatelessWidget {
  final Color color;
  final String actionText;
  final String cancelText;
  final String dialogText;
  final VoidCallback cancelCallback;
  final VoidCallback actionCallback;

  const StyledDialog(
      {super.key,
      required this.color,
      required this.actionText,
      required this.cancelText,
      required this.dialogText,
      required this.cancelCallback,
      required this.actionCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color,
      shape: const Border(
        top: BorderSide(width: 2.0, color: Colors.black),
        left: BorderSide(width: 2.0, color: Colors.black),
        right: BorderSide(width: 2.0, color: Colors.black),
        bottom: BorderSide(width: 4.0, color: Colors.black),
      ),
      actions: [
        TextButton(onPressed: cancelCallback, child: Text(cancelText)),
        StyledButton(
            buttonColor: color, onPressed: actionCallback, text: actionText),
      ],
      content: Text(dialogText),
    );
  }
}
