import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styleddialog.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:realm/realm.dart';

class DeleteCategoryDialog extends StatefulWidget {
  const DeleteCategoryDialog({super.key});

  @override
  State<DeleteCategoryDialog> createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<DeleteCategoryDialog> {
  late Realm realm;
  final _debouncer = Debouncer();
  TextEditingController categoryController = TextEditingController();

  _DeleteCategoryDialogState() {
    final config =
        Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
    realm = Realm(config);
  }

  RealmResults<Category>? categories;

  void handleDeleteCategory(Category currentCategory) {
    realm.write(() {
      realm.delete<Category>(currentCategory);
      const duration = Duration(milliseconds: 250);
      _debouncer.debounce(
        duration: duration,
        onDebounce: () {
          setState(() {});
          Navigator.of(context).pop();
        },
      );
    });
  }

  void getCategories() async {
    setState(() {
      categories = realm.all<Category>();
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Category"),
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
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text("Close"))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories!.length,
                itemBuilder: (context, i) {
                  var category = categories!.elementAt(i);
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StyledDialog(
                            type: DialogType.warning,
                            title: "Delete category",
                            actionText: "Delete",
                            cancelText: "Cancel",
                            dialogText:
                                "Are you sure you want to delete this category?",
                            cancelCallback: () {
                              Navigator.pop(context);
                            },
                            actionCallback: () {
                              handleDeleteCategory(category);
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: HexColor(category.color),
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(
                          top: BorderSide(width: 2.0, color: Colors.black),
                          left: BorderSide(width: 2.0, color: Colors.black),
                          right: BorderSide(width: 2.0, color: Colors.black),
                          bottom: BorderSide(width: 4.0, color: Colors.black),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category.name),
                          const Icon(FontAwesomeIcons.solidTrashCan)
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
