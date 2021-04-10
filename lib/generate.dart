import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_generator/barcode_generator.dart';


class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String codeData;
  TextEditingController qrTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text('Generate QR code'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  trailing: TextButton(
                    child: Text(
                      "ENTER",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue),

                    ),
                    onPressed: () {
                      setState(() {
                        codeData = qrTextController.text;
                        (codeData == null || codeData == "")
                            ? Center(child: Text("enter some text to display qr code..."))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleGeneratedPage(textToGenerate:
                                      qrTextController.text),
                                )
                            );
                      });
                    },
                  ),
                  title: TextField(
                    controller: qrTextController,
                    decoration: InputDecoration(
                      hintText: "please enter some data",
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      );
    } on Exception catch (e, s) {
      print(s);
    }
  }
}


class SingleGeneratedPage extends StatelessWidget {
  final String textToGenerate;
  SingleGeneratedPage({Key key, @required this.textToGenerate}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
              width: 500,
              height: 500,
              color: Colors.black26,
              child: BarcodeGenerator(
                backgroundColor: Colors.white,
                fromString: textToGenerate,
                codeType: BarCodeType.kBarcodeFormatQRCode,
              )),
        ),
      );
  }
}


