import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styleddialog.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:realm/realm.dart';

class SetCategoryDialog extends StatefulWidget {
  final ObjectId existingNoteId;
  const SetCategoryDialog({super.key, required this.existingNoteId});

  @override
  State<SetCategoryDialog> createState() => _SetCategoryDialogState();
}

class _SetCategoryDialogState extends State<SetCategoryDialog> {
  late Realm realm;
  final _debouncer = Debouncer();
  TextEditingController categoryController = TextEditingController();

  _SetCategoryDialogState() {
    final config =
        Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
    realm = Realm(config);
  }

  Note? _currentNote;
  RealmResults<Category>? categories;

  void handleSetCategory(Category currentCategory) {
    realm.write(() {
      _currentNote!.category = currentCategory;
      _currentNote!.updatedAt = DateTime.now();
      setState(() {});
      const duration = Duration(milliseconds: 250);
      _debouncer.debounce(
        duration: duration,
        onDebounce: () {
          Navigator.of(context).pop();
        },
      );
    });
  }

  void getCategories() async {
    setState(() {
      categories = realm.all<Category>();
      _currentNote = realm.find<Note>(widget.existingNoteId);
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
      title: const Text("Set Category"),
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
                      handleSetCategory(category);
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
                          _currentNote!.category != null &&
                                  _currentNote!.category!.name == category.name
                              ? const Icon(FontAwesomeIcons.check)
                              : const SizedBox()
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
