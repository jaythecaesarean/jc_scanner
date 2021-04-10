import 'package:flutter/material.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
            ),
          ],
        )
    );
  }

}


