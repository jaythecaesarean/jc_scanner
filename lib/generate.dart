import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as bImage;
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:document_file_save/document_file_save.dart';


class GeneratePage extends StatefulWidget {
  const GeneratePage({
    Key key,
  }) : super(key: key);

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
                  leading: Icon(Icons.text_fields),
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
                        print(codeData);
                        if (codeData == null || codeData == "") {
                          Center(child: Text(
                              "enter some text to display qr code..."));
                        }
                        else {
                          List<int> codeImageBytes = buildBarcodeImage(codeData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleGeneratedPage(
                                      imageBytes: codeImageBytes
                                  ),
                            )
                          );
                        }
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
  final List<int> imageBytes;
  SingleGeneratedPage({Key key, @required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Generated Code'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      shareImage(imageBytes);
                    },
                    child: Icon(
                      Icons.share,
                      size: 26.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      saveImage(imageBytes).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Successfully saved on your download folder as '$value'")
                          ),
                        );
                      }
                      );
                    },
                    child: Icon(
                      Icons.save,
                      size: 26.0,
                    ),
                  ),
                ),

              ]
            ),
          ],
        ),
        body: Center(
          child: Container(
              width: 500,
              height: 500,
              color: Colors.white,
              child: Image.memory(Uint8List.fromList(imageBytes))

          ),
        ),
      );
  }


  Future<String> saveImage(List<int> imageBytes) async {
    String _dateNowInEpoch = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String _newFileName = "code"+_dateNowInEpoch + ".png";
    DocumentFileSave.saveFile(
        Uint8List.fromList(imageBytes),
        _newFileName, "image/png");
    return _newFileName;
  }

}


List<int> buildBarcodeImage(String inputText, [String format = 'DataMatrix']) {
  final image = bImage.Image(500, 500);
  final int _codeWidth = 440;
  final int _codeHeight = 440;

  BarcodeType type = BarcodeType.values.firstWhere(
          (element) => element.toString() == 'BarcodeType.' + format,
      orElse: () => BarcodeType.DataMatrix);

  bImage.fill(image, bImage.getColor(255, 255, 255));
  drawBarcode(
    image,
    Barcode.fromType(type),
    inputText,
    font: bImage.arial_24,
    width: _codeWidth,
    height: _codeHeight,
    x: 30,
    y: 30,);
  List<int> encodedPNG = bImage.encodePng(image);
  return encodedPNG;
}


void shareImage(List<int> imageBytes) async {
  final Directory temp = await getTemporaryDirectory();
  final File imageFile = File('${temp.path}/code.png');
  imageFile.writeAsBytesSync(imageBytes);
  Share.shareFiles(['${temp.path}/code.png'], );
}
