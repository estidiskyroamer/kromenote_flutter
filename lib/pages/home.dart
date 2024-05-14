import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kromenote_flutter/common/components/addcategorydialog.dart';
import 'package:kromenote_flutter/common/components/deletecategorydialog.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';
import 'package:kromenote_flutter/database/models/models.dart';
import 'package:kromenote_flutter/pages/note.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:realm/realm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Realm realm;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _HomeScreenState() {
    final config = Configuration.local([Note.schema, Category.schema]);
    realm = Realm(config);
  }

  RealmResults<Note>? notes;
  RealmResults<Category>? categories;

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
      endDrawer: Drawer(
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
                onTap: () {},
                title: const Text("Privacy policy"),
              ),
            ],
          ),
        ),
      ),
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
                              buttonColor: HexColor(category.color),
                              text: category.name,
                              onPressed: () {}),
                        );
                      }),
                ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: notes!.isEmpty
                ? const Text("No notes")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes!.length,
                    itemBuilder: (context, i) {
                      var note = notes!.elementAt(i);
                      return GestureDetector(
                        onTap: () async {
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
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                top:
                                    BorderSide(width: 2.0, color: Colors.black),
                                left:
                                    BorderSide(width: 2.0, color: Colors.black),
                                right:
                                    BorderSide(width: 2.0, color: Colors.black),
                                bottom:
                                    BorderSide(width: 4.0, color: Colors.black),
                              ),
                              color: note.category != null
                                  ? HexColor(note.category!.color)
                                  : Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.title),
                              note.updatedAt != null
                                  ? Text(DateFormat('dd MMM yyyy, HH:mm')
                                      .format(note.updatedAt!))
                                  : Text(DateFormat('dd MMM yyyy, HH:mm')
                                      .format(note.createdAt!))
                            ],
                          ),
                        ),
                      );
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
}
