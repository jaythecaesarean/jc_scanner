import 'dart:io';
import 'dart:developer';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();

}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final picker = ImagePicker();
  Barcode result;
  QRViewController controller;
  String _dataOnSavedImage;
  String _imagePath;


  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                getImagePath().then((value){
                  if (_imagePath != null) {
                    decodeDataFromFile(_imagePath)
                        .then((imageData) {
                          if (imageData == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("No Image selected!!!")));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleScannedPage(text: imageData,),
                                )).then((value) => controller.resumeCamera());
                          }
                        })
                        .catchError((error, stackTrace){
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No QR Detected on the image")),
                          );
                        });
                  }
                });
              },
              child: Icon(
                Icons.image_search,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      )
    );
  }



  Future<String> getImagePath() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
        return _imagePath;
      } else {
        print('No image selected.');
        return null;
      }
    });
  }


  /// decode from local file
  Future<String> decodeDataFromFile(String filepath) async {
    String data = await QrCodeToolsPlugin.decodeFrom(filepath);
    setState(() {
      _dataOnSavedImage = data;
    });
    return data;
  }



  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool scanned = false;
    controller.scannedDataStream.listen((scanData) {
      if(!scanned) {
        this.controller.stopCamera();
        setState(() {
          result = scanData;
          String resultCode = result.code;
          log("result: $resultCode");
          _sendDataToHistory(context);
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  void _sendDataToHistory (BuildContext context) {
    // controller.stopCamera();
    String textToSend = result.code;
    var value = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleScannedPage(text: textToSend,),
        )).then((value) => controller.resumeCamera());
  }
}


class SingleScannedPage extends StatelessWidget {
  final String text;
  SingleScannedPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Code Details')),
      body: Center(
        child: SelectableLinkify(
          onOpen: _onOpen,
          text: text,
          style: TextStyle(fontSize: 20),
          options: LinkifyOptions(humanize: false),

        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

