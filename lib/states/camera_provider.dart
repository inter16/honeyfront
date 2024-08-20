import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  List<Map<String, String>> _cameras = [];

  List<Map<String, String>> get cameras => _cameras;

  void setCameras(List<Map<String, String>> cameras) {
    _cameras = cameras;
    notifyListeners();
  }

  void addCamera(Map<String, String> camera) {
    _cameras.add(camera);
    notifyListeners();
  }
}
