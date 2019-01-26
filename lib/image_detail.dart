import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

class ImageDetail extends StatefulWidget {
  ImageDetail(this.filePath);

  final String filePath;

  @override
  _ImageDetailState createState() => new _ImageDetailState(filePath);
}

class _ImageDetailState extends State<ImageDetail> {
  _ImageDetailState(this.filePath);

  final String filePath;

  String recognizedText = "Loading ...";

  void _initializeVision() async {
    // get image file
    final File imageFile = File(filePath);

    // create vision image from that file
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    // create detector index
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    // find text in image
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    // got the pattern from that SO answer: https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
    String mailPattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(mailPattern);

    String mailAddress =
        "Couldn't find any mail in the foto! Please try again!";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(line.text)) {
          mailAddress = line.text;
        }
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedText = mailAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeVision();

    return Scaffold(
        appBar: AppBar(title: Text("Taken Photo")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: new Container(
                height: 300,
                child: Center(child: Image.file(File(filePath))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                "Extracted Text:",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  recognizedText,
                  style: Theme.of(context).textTheme.body1,
                )),
          ],
        ));
  }
}
