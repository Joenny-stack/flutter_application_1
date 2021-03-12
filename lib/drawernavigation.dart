import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/showdata.dart';
import 'package:flutter_application_1/settings.dart';

import 'englishwords.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  adminDialog(BuildContext context) {
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
                onPressed: () {},
                child: Text('Select Location'),
                color: Colors.blue,
              ),
            ],
            title: Text('Export Database'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter database name.',
                      labelText: 'English',
                    ),
                  ),
                  TextField(
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

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {}
                },
                child: Text('Yes'),
                color: Colors.blueAccent,
              ),
            ],
            title: Text('Are you sure you want to exit?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/cloudicon.jpg'),
              ),
              accountName: Text('Translation Database'),
              accountEmail: Text('Ndebele'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Translation home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ShowData())),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('English Dictionary'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Definitions())),
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Settings'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage())),
              // adminDialog(context);
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '1.0',
                  applicationName: 'Translation Database',
                  applicationLegalese: 'Ndebele',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit'),
              onTap: () {
                _showFormDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
