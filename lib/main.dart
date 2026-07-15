import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'presentation/hidden_camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HiddenCameraScreen(camera: cameras.first),
    ),
  );
}