// import 'package:flutter/material.dart';w
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
//
// class StreamingPage extends StatefulWidget {
//   @override
//   _StreamingPageState createState() => _StreamingPageState();
// }
//
// class _StreamingPageState extends State<StreamingPage> {
//   late WebViewController _webViewController;
//   final ScreenshotController _screenshotController = ScreenshotController();
//   bool _isRecording = false;
//
//   void _startRecording() async {
//     if (_isRecording) {
//       String? path = await FlutterScreenRecording.stopRecordScreen;
//       setState(() {
//         _isRecording = false;
//       });
//       if (path != null) {
//         // Handle the recorded video
//         print('Recording saved to $path');
//       }
//     } else {
//       bool started = await FlutterScreenRecording.startRecordScreen(
//         "Recording",
//         titleNotification: "Screen Recording",
//         messageNotification: "Screen recording is running...",
//       );
//       setState(() {
//         _isRecording = started;
//       });
//       if (started) {
//         print('Recording started');
//       }
//     }
//   }
//
//   void _captureScreenshot() async {
//     final image = await _screenshotController.capture();
//     if (image != null) {
//       // Save or do something with the image
//       print('Screenshot captured');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Webview with Recording and Capture'),
//       ),
//       body: Screenshot(
//         controller: _screenshotController,
//         child: Stack(
//           children: [
//             WebView(
//               initialUrl: 'http://honeybeecombo.ddns.net:8081',
//               onWebViewCreated: (controller) {
//                 _webViewController = controller;
//               },
//               javascriptMode: JavascriptMode.unrestricted,
//               onPageFinished: (url) {
//                 _injectCSS(_webViewController);
//               },
//             ),
//             Positioned(
//               bottom: 20,
//               left: 20,
//               child: ElevatedButton(
//                 onPressed: _startRecording,
//                 child: Text(_isRecording ? '정지' : '녹화'),
//               ),
//             ),
//             Positioned(
//               bottom: 20,
//               right: 20,
//               child: ElevatedButton(
//                 onPressed: _captureScreenshot,
//                 child: const Text('캡쳐'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _injectCSS(WebViewController controller) {
//     controller.runJavascript(
//         '''
//       (function() {
//         function applyTransform() {
//           var videos = document.querySelectorAll('video');
//           videos.forEach(function(video) {
//             video.style.transform = 'scaleX(-1)';
//           });
//         }
//         applyTransform();
//         setInterval(applyTransform, 1000);
//       })();
//       '''
//     );
//   }
// }