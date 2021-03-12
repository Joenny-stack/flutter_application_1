import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/drawernavigation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Definitions extends StatefulWidget {
  @override
  _DefinitionsState createState() => _DefinitionsState();
}

class _DefinitionsState extends State<Definitions> {
  Database _database;
  String word = "", trans = "";
  bool likevalue = true;
  List dbQuery = [];
  String searchtext;
  TextEditingController _controller = TextEditingController();

  String get path => null;

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        margin: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(100, 255, 255, 255),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: TextFormField(
                autofocus: false,
                controller: _controller,
                style: TextStyle(color: Colors.white),
                onChanged: (text) {
                  if (text != '') {
                    queryDB(text);
                  } else {
                    initalizeDB();
                  }
                },
                // onFieldSubmitted: getData,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                  icon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("   English Dictionary"),
            searchBar(),
          ],
        ),
        centerTitle: true,
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
          itemCount: dbQuery.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(0.1),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 6.0,
                    left: 3.0,
                    right: 3.0,
                    bottom: 3.0,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    leading: Icon(Icons.copy),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dbQuery[index]['word'],
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          iconSize: 20.0,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    // trailing: Icon(Icons.add),
                    children: [
                      Text(
                        dbQuery[index]['definition'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void initalizeDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "assets/engdictionary.db");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "engdictionary.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    _database = await openDatabase(path, readOnly: true);
    dbQuery = await _database.rawQuery('SELECT * FROM entries;');

    setState(() {
      //   for (var i = 0; i < 5; i++) word = dbQuery[i]["english"];
      trans = dbQuery[1]["ndebele"];
    });
  }

  void queryDB(String text) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "assets/engdictionary.db");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "engdictionary.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    _database = await openDatabase(path, readOnly: true);
    if (likevalue) {
      dbQuery = await _database
          .rawQuery("SELECT * FROM entries where word LIKE '$text%'");
    } else {
      dbQuery = await _database
          .rawQuery("SELECT * FROM entries where word = '$text'");
    }

    setState(() {
      trans = dbQuery[1]["word"];
      // likevalue = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initalizeDB();

    // _controller.addListener(_latestSearch(),);
  }
}
