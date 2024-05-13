import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:realm/realm.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  List<String> colorList = [
    "#ffcccc", "#ffb3b3", "#ff9999", "#ff8080", "#ff6666", "#ff4d4d", // Red
    "#ffd9b3", "#ffcc99", "#ffbf80", "#ffb266", "#ff9933", "#ff8000", // Orange
    "#ffffb3", "#ffff99", "#ffff80", "#ffff66", "#ffff4d", "#ffff33", // Yellow
    "#b3ffb3", "#99ff99", "#80ff80", "#66ff66", "#4dff4d", "#33ff33", // Green
    "#b3b3ff", "#9999ff", "#8080ff", "#6666ff", "#4d4dff", "#3333ff", // Blue
    "#ffffff", "#f2f2f2", "#e6e6e6", "#d9d9d9", "#cccccc", "#bfbfbf" // White
  ];
  String selectedColor = '#ffffff';

  late Realm realm;
  TextEditingController categoryController = TextEditingController();

  _AddCategoryDialogState() {
    final config = Configuration.local([Note.schema, Category.schema]);
    realm = Realm(config);
  }

  void handleSaveCategory() {
    final name = categoryController.text;
    if (name.isEmpty) return;
    var category = Category(ObjectId(), name, selectedColor);

    realm.write(
      () {
        realm.add<Category>(category);
      },
    );
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const Border(
        top: BorderSide(width: 2.0, color: Colors.black),
        left: BorderSide(width: 2.0, color: Colors.black),
        right: BorderSide(width: 2.0, color: Colors.black),
        bottom: BorderSide(width: 4.0, color: Colors.black),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        StyledButton(
            buttonColor: HexColor("#c2ffac"),
            onPressed: handleSaveCategory,
            text: "Add"),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              border: DashedBorder(
                  dashLength: 6,
                  bottom: BorderSide(width: 1.5, color: Colors.black)),
            ),
            child: TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                  hintText: "Category name", border: InputBorder.none),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6),
                itemCount: colorList.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: selectedColor == colorList[index]
                        ? StyledButton(
                            buttonColor: HexColor(colorList[index]),
                            size: 16,
                            icon: FontAwesomeIcons.check,
                            onPressed: () {
                              setState(() {
                                selectedColor = colorList[index];
                              });
                            },
                          )
                        : StyledButton(
                            buttonColor: HexColor(colorList[index]),
                            text: " ",
                            onPressed: () {
                              setState(() {
                                selectedColor = colorList[index];
                              });
                            },
                          ),
                  );
                })),
          )
        ],
      ),
    );
  }
}
