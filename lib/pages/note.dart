import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: StyledButton(
            icon: FontAwesomeIcons.arrowLeft,
            buttonColor: HexColor("#d9d9d9"),
            onPressed: () {
              Navigator.pop(context);
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
                  onTap: () {},
                  title: const Text("Delete note"),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: const TextField(
                decoration: InputDecoration(
                    hintText: "Title goes here",
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 2.0,
                      color: Colors.black38,
                    ))),
              ),
            )
          ],
        ));
  }
}
