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

  void removeCamera(Map<String, String> camera) {
    _cameras.remove(camera);
    notifyListeners();
  }

  // 특정 인덱스를 기준으로 카메라 삭제하는 방법
  void removeCameraAt(int index) {
    if (index >= 0 && index < _cameras.length) {
      _cameras.removeAt(index);
      notifyListeners();
    }
  }
}
