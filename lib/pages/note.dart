import 'dart:convert';
import 'dart:developer';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:realm/realm.dart';

class NoteScreen extends StatefulWidget {
  final Note? existingNote;

  const NoteScreen({super.key, this.existingNote});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final config = Configuration.local([Note.schema, Category.schema]);
  final _debouncer = Debouncer();
  Note? _currentNote;
  TextEditingController titleController = TextEditingController();
  FleatherController contentController = FleatherController();

  void handleSaveNote() {
    final realm = Realm(config);
    const duration = Duration(milliseconds: 750);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        final content = jsonEncode(contentController.document);
        final title = titleController.text;
        if (title.isNotEmpty) {
          var note = Note(ObjectId(), title,
              content: content, createdAt: DateTime.now());
          if (_currentNote != null) {
            note.id = _currentNote!.id;
            note.updatedAt = DateTime.now();
          }
          if (_currentNote!.title != note.title ||
              _currentNote!.content != note.content) {
            realm.write(
              () {
                realm.add<Note>(note, update: true);
                if (mounted) {
                  setState(() {
                    _currentNote = note;
                  });
                }
              },
            );
          }
        }
      },
    );
  }

  void getCurrentNote() async {
    if (widget.existingNote != null) {
      setState(() {
        _currentNote = widget.existingNote!;
        final document = loadDocument(_currentNote!.content!);
        contentController = FleatherController(document: document);
      });
    }
  }

  ParchmentDocument loadDocument(String document) {
    return ParchmentDocument.fromJson(jsonDecode(document));
  }

  @override
  void initState() {
    super.initState();
    getCurrentNote();
    titleController.addListener(handleSaveNote);
    contentController.addListener(handleSaveNote);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = _currentNote != null ? _currentNote!.title : '';
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StyledButton(
            icon: FontAwesomeIcons.arrowLeft,
            buttonColor: HexColor("#d9d9d9"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: StyledButton(
                icon: FontAwesomeIcons.wrench,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: const BoxDecoration(
                border: DashedBorder(
                    dashLength: 6,
                    bottom: BorderSide(width: 1.5, color: Colors.black)),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Title goes here", border: InputBorder.none),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _currentNote != null && _currentNote!.updatedAt != null
                      ? Text(
                          "Updated at ${DateFormat('dd MMM yyyy, HH:mm:ss').format(_currentNote!.updatedAt!)}")
                      : _currentNote != null && _currentNote!.createdAt != null
                          ? Text(
                              "Created at ${DateFormat('dd MMM yyyy, HH:mm:ss').format(_currentNote!.createdAt!)}")
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
            editorToolbar(),
          ],
        ));
  }

  Container editorToolbar() {
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
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.italic,
            icon: FontAwesomeIcons.italic,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.underline,
            icon: FontAwesomeIcons.underline,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.strikethrough,
            icon: FontAwesomeIcons.strikethrough,
            controller: contentController,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.left,
            icon: FontAwesomeIcons.alignLeft,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.right,
            icon: FontAwesomeIcons.alignRight,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.center,
            icon: FontAwesomeIcons.alignCenter,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.justify,
            icon: FontAwesomeIcons.alignJustify,
            controller: contentController,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.ol,
            icon: FontAwesomeIcons.listOl,
            controller: contentController,
          ),
          ToggleStyleButton(
            attribute: ParchmentAttribute.ul,
            icon: FontAwesomeIcons.listUl,
            controller: contentController,
          ),
        ],
      ),
    );
  }

  Dialog deleteDialog() {
    return Dialog(
      shape: const Border(
        top: BorderSide(width: 2.0, color: Colors.black),
        left: BorderSide(width: 2.0, color: Colors.black),
        right: BorderSide(width: 2.0, color: Colors.black),
        bottom: BorderSide(width: 4.0, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Text("Are you sure you want to delete this note?"),
          Row(
            children: [
              StyledButton(
                buttonColor: Colors.red,
                text: "Delete",
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }

  Drawer endDrawer(void deleteNoteFunction) {
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
              onTap: () {},
              title: const Text("Set password"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Remove password"),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Set category"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Remove category"),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            ListTile(
              onTap: () {
                _scaffoldKey.currentState!.closeEndDrawer();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          StyledButton(
                              buttonColor: Colors.red,
                              onPressed: () {},
                              text: "Delete"),
                        ],
                        content: const Text(
                            "Are you sure you want to delete this note?"),
                      );
                    });
              },
              title: const Text("Delete note"),
            ),
          ],
        ),
      ),
    );
  }
}
