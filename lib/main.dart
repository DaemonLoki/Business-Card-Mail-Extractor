import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mail Extractor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicturePressed() {

  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: Text("Controller is not yet initialized!"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: RaisedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Take Picture"),
                  onPressed: _takePicturePressed,
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
