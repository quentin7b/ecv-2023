import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CharacterAddPage extends StatefulWidget {
  const CharacterAddPage({super.key});
  @override
  State<CharacterAddPage> createState() => _CharacterAddPageState();
}

class _CharacterAddPageState extends State<CharacterAddPage> {
  late CameraController _controller;
  bool isCameraInit = false;

  @override
  void initState() {
    super.initState();
    initCameras();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void initCameras() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    setState(() {
      isCameraInit = true;
    });
  }

  void takePicture(BuildContext context) async {
    final image = await _controller.takePicture();
    Navigator.pop(context, image.path);
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraInit) {
      // If the Future is complete, display the preview.
      return Scaffold(
        body: CameraPreview(_controller),
        floatingActionButton: FloatingActionButton(
          onPressed: () => takePicture(context),
          child: const Icon(Icons.camera_outlined),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
