import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawernavigation.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(

          ),
          ListTile(
            
          ),
          ListTile(
            
          ),
          ExpansionTile(title: Text('Theme'),)
        ],
      ),
    );
  }
}
