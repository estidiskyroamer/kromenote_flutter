import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kromenote_flutter/common/components/addcategorydialog.dart';
import 'package:kromenote_flutter/common/components/blockshadowborder.dart';
import 'package:kromenote_flutter/common/components/bottomsheet.dart';
import 'package:kromenote_flutter/common/components/deletecategorydialog.dart';
import 'package:kromenote_flutter/common/components/privacypolicydialog.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';
import 'package:kromenote_flutter/common/components/styleddialog.dart';
import 'package:kromenote_flutter/common/components/styledtextfield.dart';
import 'package:kromenote_flutter/common/components/styledtoast.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:kromenote_flutter/pages/note.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:realm/realm.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Realm realm;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _HomeScreenState() {
    final config =
        Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
    realm = Realm(config);
  }

  RealmResults<Note>? notes;
  RealmResults<Category>? categories;
  Category? currentCategory;
  final _debouncer = Debouncer();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCategories();
    getNotes();
  }

  void getNotes() async {
    setState(() {
      notes = realm.all<Note>();
    });
  }

  void getCategories() async {
    setState(() {
      categories = realm.all<Category>();
    });
  }

  void getCategory(Category selectedCategory) {
    setState(() {
      if (currentCategory != null) {
        currentCategory = null;
        getNotes();
      } else {
        currentCategory = realm.find<Category>(selectedCategory.id);
        notes = currentCategory!.getBacklinks<Note>('category');
      }
    });
  }

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

  void handleInputPassword(Note note, VoidCallback callback) {
    var bytes = utf8.encode(passwordController.text);
    var hashedPassword = sha256.convert(bytes).toString();
    note.password == hashedPassword
        ? callback()
        : styledToast(ToastificationType.error, "Wrong password");
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("KromeNote"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StyledButton(
              icon: FontAwesomeIcons.gear,
              buttonColor: HexColor("#d9d9d9"),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: endDrawer(),
      body: Column(
        children: [
          categories!.isEmpty
              ? const SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: categories!.length,
                    itemBuilder: (context, i) {
                      var category = categories!.elementAt(i);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: StyledButton(
                          isDisabled: currentCategory == null
                              ? false
                              : currentCategory == category
                                  ? false
                                  : true,
                          buttonColor: HexColor(category.color),
                          text: category.name,
                          onPressed: () {
                            getCategory(category);
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return bottomSheet(
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(FontAwesomeIcons.pencil),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: const Text("Edit category"),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            FontAwesomeIcons.trashCan),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StyledDialog(
                                                type: DialogType.warning,
                                                title: "Delete category",
                                                actionText: "Delete",
                                                cancelText: "Cancel",
                                                dialogText:
                                                    "Are you sure you want to delete this category? Any notes in this category will become uncategorized.",
                                                cancelCallback: () {
                                                  Navigator.pop(context);
                                                },
                                                actionCallback: () {
                                                  handleDeleteCategory(
                                                      category);
                                                },
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        title: const Text("Delete category"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
          notes!.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "No notes.",
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes!.length,
                      itemBuilder: (context, i) {
                        var note = notes!.elementAt(i);
                        return noteItem(note, context);
                      }),
                ),
        ],
      ),
      floatingActionButton: StyledButton(
        icon: FontAwesomeIcons.plus,
        size: 36,
        buttonColor: HexColor("#6eb9ff"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteScreen(),
            ),
          );
          getNotes();
        },
      ),
    );
  }

  GestureDetector noteItem(Note note, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        note.password != null
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StyledDialog(
                    type: DialogType.update,
                    title: "Enter Password",
                    actionText: "Enter",
                    cancelText: "Cancel",
                    dialogText: "test",
                    content: styledTextField(
                        passwordController, "Input password",
                        isPassword: true,
                        inputType: TextInputType.visiblePassword),
                    cancelCallback: () {
                      passwordController.clear();
                      Navigator.pop(context);
                    },
                    actionCallback: () async {
                      Navigator.pop(context);
                      handleInputPassword(
                        note,
                        () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteScreen(
                                existingNoteId: note.id,
                              ),
                            ),
                          );
                          getNotes();
                        },
                      );
                      passwordController.clear();
                    },
                  );
                },
              )
            : await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(
                    existingNoteId: note.id,
                  ),
                ),
              );
        getNotes();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: blockShadowBorder(4.0),
            color: note.category != null
                ? HexColor(note.category!.color)
                : Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  note.updatedAt != null
                      ? Text(
                          "Updated at ${DateFormat('dd MMM yyyy, HH:mm').format(note.updatedAt!)}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5)),
                        )
                      : Text(
                          "Created at ${DateFormat('dd MMM yyyy, HH:mm').format(note.createdAt!)}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                ],
              ),
            ),
            note.password != null
                ? Icon(
                    FontAwesomeIcons.lock,
                    color: Colors.black.withOpacity(0.35),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Drawer endDrawer() {
    return Drawer(
      shape: const ContinuousRectangleBorder(
          side: BorderSide(width: 4.0, color: Colors.black)),
      elevation: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: StyledButton(
                icon: FontAwesomeIcons.arrowLeft,
                buttonColor: HexColor("#d9d9d9"),
                onPressed: () {
                  _scaffoldKey.currentState!.closeEndDrawer();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                _scaffoldKey.currentState!.closeEndDrawer();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddCategoryDialog();
                    }).then((value) => setState(() {}));
              },
              title: const Text("Add category"),
            ),
            categories!.isEmpty
                ? const SizedBox()
                : ListTile(
                    onTap: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const DeleteCategoryDialog();
                          }).then((value) => setState(() {}));
                    },
                    title: const Text("Delete category"),
                  ),
            const Padding(padding: EdgeInsets.all(12)),
            ListTile(
              onTap: () {
                _scaffoldKey.currentState!.closeDrawer();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const PrivacyPolicyDialog();
                    });
              },
              title: const Text("Privacy policy"),
            ),
          ],
        ),
      ),
    );
  }
}
