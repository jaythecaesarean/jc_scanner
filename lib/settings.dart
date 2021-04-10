import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Privacy Policy"),
              onTap: () {
                _onOpenSettingsLink("http://scanner.jaycaesar.xyz/privacy.html");
              },
            ),
            ListTile(
              title: Text("About"),
              onTap: (){
                _showAboutDialog();
              },
            ),
          ],
        )
    );
  }

  Future<void> _onOpenSettingsLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  Future<void> _showAboutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About JC Scanner'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('JC Scanner version 1.0.0'),
                Text('Created by JayCaesar.xyz'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


