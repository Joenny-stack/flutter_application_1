import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/drawernavigation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  // List dbQuery = [];
  Database _database;
  String word = "", trans = "";
  bool likevalue = true;

  List dbQuery = [];
  String searchtext;
  TextEditingController _controller = TextEditingController();
  TextEditingController _ndebele = TextEditingController();
  TextEditingController _english = TextEditingController();

  String get path => null;
  // List dbQuery2 = List();

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true, // _latestSearch() {
        //   searchtext = _controller.text;
        // }
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () {
                  if (_ndebele.text != '') {
                    if (_english.text != '') {
                      addwords(_english.text, _ndebele.text);
                    } else {
                      print("Enter English");
                    }
                  } else {
                    print("Enter Ndebele");
                  }
                },
                child: Text('Save'),
                color: Colors.blue,
              ),
            ],
            title: Text('Add New Word'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _english,
                    decoration: InputDecoration(
                      hintText: 'write english phrase...',
                      labelText: 'English',
                    ),
                  ),
                  TextField(
                    controller: _ndebele,
                    decoration: InputDecoration(
                      hintText: ' write ndebele translation...',
                      labelText: 'Ndebele',
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

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
                    onPressed: () {
                      // setState(() {
                      //   likevalue = false;
                      // });
                    },
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Translation Database"),
          searchBar(),
        ]),
        centerTitle: true,
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
          itemCount: dbQuery.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(0.5),
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
                        children: [
                          Text(
                            dbQuery[index]['english'],
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(
                          //   width: 30.0,
                          // ),
                          // IconButton(
                          //   icon: Icon(Icons.volume_up),
                          //   iconSize: 20.0,
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                      // trailing: Icon(Icons.add),
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 0.0, 20.0),
                              child: Text(
                                dbQuery[index]['ndebele'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void initalizeDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "assets/dictionary.db");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "dictionary.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    _database = await openDatabase(path, readOnly: false);
    dbQuery = await _database.rawQuery('SELECT * FROM Words;');

    setState(() {
      //   for (var i = 0; i < 5; i++) word = dbQuery[i]["english"];
      trans = dbQuery[1]["ndebele"];
    });
  }

  void queryDB(String text) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "assets/dictionary.db");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "dictionary.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    _database = await openDatabase(path, readOnly: false);
    if (likevalue) {
      dbQuery = await _database
          .rawQuery("SELECT * FROM Words where english LIKE '$text%'");
    } else {
      dbQuery = await _database
          .rawQuery("SELECT * FROM Words where english = '$text'");
    }

    setState(() {
      trans = dbQuery[1]["ndebele"];
      // likevalue = true;
    });
  }

  void addwords(String eng, String ndeb) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "assets/dictionary.db");
    _database = await openDatabase(path, readOnly: false);
    _database.execute('Insert INTO Words Values("$ndeb", "$eng")');
    print("Done");

    setState(() {
      trans = dbQuery[1]["ndebele"];
      //dsjkjd
    });
  }

  @override
  void initState() {
    super.initState();
    initalizeDB();

    // _controller.addListener(_latestSearch(),);
  }
}
