import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kromenote_flutter/common/components/editortoolbar.dart';
import 'package:kromenote_flutter/common/components/setcategorydialog.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';
import 'package:kromenote_flutter/common/components/styleddialog.dart';
import 'package:kromenote_flutter/common/components/styledtextfield.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:kromenote_flutter/pages/home.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:realm/realm.dart';

class NoteScreen extends StatefulWidget {
  // final Note? existingNote;
  final ObjectId? existingNoteId;

  const NoteScreen({super.key, this.existingNoteId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final config =
      Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
  late Realm realm;
  final _debouncer = Debouncer();
  Note? _currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FleatherController contentController = FleatherController();
  String themeColor = '#ffffff';
  bool isChanged = false;

  _NoteScreenState() {
    final config =
        Configuration.local([Note.schema, Category.schema], schemaVersion: 1);
    realm = Realm(config);
  }

  void checkChangedState() {
    final content = jsonEncode(contentController.document);
    final title = titleController.text;
    if (mounted) {
      setState(() {
        isChanged = false;
      });
    }
    if ((_currentNote != null &&
            (_currentNote!.title != title ||
                _currentNote!.content != content)) ||
        _currentNote == null &&
            (content != '[{"insert":"\\n"}]' || title.isNotEmpty)) {
      if (mounted) {
        setState(() {
          isChanged = true;
        });
      }
    }
  }

  void handleSaveNote() {
    const duration = Duration(milliseconds: 750);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        final content = jsonEncode(contentController.document);
        final title = titleController.text;
        if (title.isEmpty) return;

        var note = Note(ObjectId(), title,
            content: content, createdAt: DateTime.now());
        if (_currentNote != null) {
          note = Note(_currentNote!.id, title,
              content: content,
              category: _currentNote!.category,
              createdAt: _currentNote!.createdAt,
              updatedAt: DateTime.now());
        }

        realm.write(
          () {
            realm.add<Note>(note, update: true);
            if (mounted) {
              setState(() {
                _currentNote = note;
                isChanged = false;
              });
            }
          },
        );
      },
    );
  }

  void handleDeleteNote() {
    realm.write(() {
      realm.delete<Note>(_currentNote!);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen()));
    });
  }

  void handleSetPassword(String password) {
    var bytes = utf8.encode(password);
    var hashedPassword = sha256.convert(bytes).toString();
    realm.write(() {
      _currentNote!.password = hashedPassword;
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

  void handleRemovePassword(String password) {
    var bytes = utf8.encode(password);
    var hashedPassword = sha256.convert(bytes).toString();
    realm.write(() {
      if (_currentNote!.password == hashedPassword) {
        _currentNote!.password = null;
      } else
        print('wrong password');
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

  void handleRemoveCategory() {
    realm.write(() {
      _currentNote!.category = null;
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

  void handleGetNote() async {
    if (widget.existingNoteId != null) {
      setState(() {
        _currentNote = realm.find<Note>(widget.existingNoteId);
        if (_currentNote!.category != null) {
          themeColor = _currentNote!.category!.color;
        }
        final document = loadDocument(_currentNote!.content!);
        contentController = FleatherController(document: document);
        titleController.text = _currentNote!.title;
      });
    }
  }

  ParchmentDocument loadDocument(String document) {
    return ParchmentDocument.fromJson(jsonDecode(document));
  }

  @override
  void initState() {
    super.initState();
    handleGetNote();

    contentController.addListener(checkChangedState);
    titleController.addListener(checkChangedState);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  HexColor(themeColor),
                  HexColor(themeColor).withOpacity(0)
                ],
              ),
            ),
          ),
          title: StyledButton(
            icon: FontAwesomeIcons.arrowLeft,
            buttonColor: HexColor("#d9d9d9"),
            onPressed: () {
              if (isChanged) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StyledDialog(
                      type: DialogType.warning,
                      title: "Unsaved changes",
                      actionCallback: () {
                        Navigator.pop(context);
                      },
                      cancelCallback: () {
                        Navigator.pop(context);
                        Navigator.of(context).pop();
                      },
                      actionText: "Continue editing",
                      cancelText: "Leave",
                      content: const Text(
                          "Are you sure you want to leave? Unsaved changes will be lost."),
                    );
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            isChanged
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: StyledButton(
                      icon: FontAwesomeIcons.solidFloppyDisk,
                      buttonColor: HexColor("#c2ffac"),
                      onPressed: () {
                        handleSaveNote();
                      },
                    ),
                  )
                : const SizedBox(),
            _currentNote != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: StyledButton(
                      icon: FontAwesomeIcons.wrench,
                      buttonColor: HexColor("#d9d9d9"),
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        endDrawer: endDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            styledTextField(titleController, "Title goes here", fontSize: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _currentNote != null && _currentNote!.updatedAt != null
                      ? Text(
                          "Updated at ${DateFormat('dd MMM yyyy, HH:mm:ss').format(_currentNote!.updatedAt!)}",
                          style: const TextStyle(fontSize: 12),
                        )
                      : _currentNote != null && _currentNote!.createdAt != null
                          ? Text(
                              "Created at ${DateFormat('dd MMM yyyy, HH:mm:ss').format(_currentNote!.createdAt!)}",
                              style: const TextStyle(fontSize: 12),
                            )
                          : Container(),
                ),
              ],
            ),
            Expanded(
              child: FleatherEditor(
                controller: contentController,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              ),
            ),
            editorToolbar(contentController, themeColor),
          ],
        ));
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
                "Security",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                _scaffoldKey.currentState!.closeEndDrawer();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StyledDialog(
                          type: DialogType.update,
                          title: "Set Password",
                          actionText: "Set",
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
                          actionCallback: () {
                            handleSetPassword(passwordController.text);
                            passwordController.clear();
                          });
                    }).then((value) => setState(() {}));
              },
              title: const Text("Set password"),
            ),
            _currentNote != null && _currentNote!.password != null
                ? ListTile(
                    onTap: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StyledDialog(
                                type: DialogType.update,
                                title: "Remove Password",
                                actionText: "Remove",
                                cancelText: "Cancel",
                                dialogText: "test",
                                content: styledTextField(passwordController,
                                    "Input password to remove",
                                    isPassword: true,
                                    inputType: TextInputType.visiblePassword),
                                cancelCallback: () {
                                  passwordController.clear();
                                  Navigator.pop(context);
                                },
                                actionCallback: () {
                                  handleRemovePassword(passwordController.text);
                                  passwordController.clear();
                                });
                          }).then((value) => setState(() {}));
                    },
                    title: const Text("Remove password"),
                  )
                : const SizedBox(),
            const Padding(padding: EdgeInsets.all(12)),
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
                      return SetCategoryDialog(
                          existingNoteId: _currentNote!.id);
                    }).then((value) => setState(() {
                      themeColor = _currentNote!.category!.color;
                    }));
              },
              title: _currentNote != null && _currentNote!.category != null
                  ? Text(
                      "Set category (current: ${_currentNote!.category!.name})")
                  : const Text("Set category"),
            ),
            _currentNote != null && _currentNote!.category != null
                ? ListTile(
                    onTap: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StyledDialog(
                            title: "Remove category",
                            actionCallback: () {
                              handleRemoveCategory();
                            },
                            cancelCallback: () {
                              Navigator.pop(context);
                            },
                            actionText: "Remove",
                            cancelText: "Cancel",
                            type: DialogType.warning,
                            content: const Text(
                                "Are you sure you want to remove the category?"),
                          );
                        },
                      ).then((value) => setState(() {
                            themeColor = "#ffffff";
                          }));
                    },
                    title: const Text("Remove category"),
                  )
                : const SizedBox(),
            const Padding(padding: EdgeInsets.all(12)),
            ListTile(
              onTap: () {
                _scaffoldKey.currentState!.closeEndDrawer();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StyledDialog(
                      title: "Delete note",
                      type: DialogType.warning,
                      actionText: "Delete",
                      cancelText: "Cancel",
                      content: const Text(
                          "Are you sure you want to delete this note?"),
                      cancelCallback: () {
                        Navigator.pop(context);
                      },
                      actionCallback: () {
                        handleDeleteNote();
                      },
                    );
                  },
                ).then((value) => setState(() {}));
              },
              title: const Text("Delete note"),
            ),
          ],
        ),
      ),
    );
  }
}
