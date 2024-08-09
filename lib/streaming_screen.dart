import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamingScreen extends StatefulWidget {
  final String? camName;

  StreamingScreen({required this.camName});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {

  ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (await Permission.photos.request().isGranted &&
        await Permission.manageExternalStorage.request().isGranted) {
      // 권한이 허용됨
    } else {
      // 권한이 거부됨
      print('11111111111111111');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장소 권한이 필요합니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: yelloMyStyle2,
          appBar: AppBar(
            backgroundColor: whiteMyStyle1,
            title: Text(
              '${widget.camName} 카메라 실시간',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    height: 300,
                    child: WebView(
                      // initialUrl: 'http://honeybeecombo.ddns.net:8081',
                      // initialUrl: '192.168.137.124:8081',
                      initialUrl: 'https://pub.dev/packages/webview_flutter',
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  ),
                ),

                SizedBox(height: 16.0,),

                Container(
                  height: 250,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    children: [
                      GridButton(icon: Icons.video_camera_back_outlined, label: '녹화', onTap: () {}),
                      GridButton(
                        icon: Icons.camera_enhance_outlined,
                        label: '캡쳐',
                        onTap: () {
                          Permission.storage.request();
                          captureScreenshot();
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        )
    );
  }

  void captureScreenshot() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getExternalStorageDirectory();
        final picturesDir = Directory('${directory!.path}/Pictures/양봉장');
        if (!picturesDir.existsSync()) {
          picturesDir.createSync(recursive: true);
        }
        String fileName =
            'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        String filePath = '${picturesDir.path}/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(image);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('스크린샷 저장됨: $filePath')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('스크린샷 캡쳐 실패')));
      }
    } else {
      print('22222222222222222');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장소 권한이 필요합니다.')));
    }
  }

}

class GridButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  GridButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: blackMyStyle2,
            width: 1.0,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}