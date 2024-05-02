import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kromenote_flutter/common/components/styledbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("KromeNotes"),
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
                onTap: () {},
                title: const Text("New category"),
              ),
              ListTile(
                onTap: () {},
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
      body: Container(),
      floatingActionButton: StyledButton(
        icon: FontAwesomeIcons.penToSquare,
        size: 36,
        buttonColor: HexColor("#6eb9ff"),
        onPressed: () {
          Navigator.pushNamed(context, '/note');
        },
      ),
    );
  }
}
