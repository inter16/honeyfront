import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/states/auth_provider.dart';
import 'package:front/theme/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class StreamingScreen extends StatefulWidget {
  final String? camName;
  final String? serialNumber;

  StreamingScreen({required this.camName, required this.serialNumber});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  ScreenshotController _screenshotController = ScreenshotController();
  bool isRecording = false;
  bool isDetecting = false;
  bool isCollectorOpen = false;
  String? _outputFilePath;
  String? _ipAddress;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchIpAddress();
  }

  Future<void> _requestPermissions() async {
    var videoStatus = await Permission.videos.status;
    var photoStatus = await Permission.photos.status;

    if (!videoStatus.isGranted || !photoStatus.isGranted) {
      var statuses = await [Permission.videos, Permission.photos].request();

      if (statuses[Permission.videos]!.isDenied || statuses[Permission.photos]!.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('비디오 및 사진 권한이 필요합니다. 설정에서 권한을 부여해주세요.'),
            action: SnackBarAction(
              label: '설정으로 가기',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _fetchIpAddress() async {
    final serialNumber = widget.serialNumber;

    if (serialNumber == null) return;

    // 서버에서 IP 주소를 가져오는 로직
    final url = Uri.parse('http://kulbul.iptime.org:8000/sensor/getip');

    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',  // 전달받은 토큰 사용
      },
      body: jsonEncode({
        'SN': serialNumber,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _ipAddress = responseData['ip'];
        print(_ipAddress);
      });
    } else {
      print('IP 주소 가져오기 실패: ${response.statusCode}');
      print(response.body);
    }
  }

  Future<void> _detectorActiveRequest() async {
    final serialNumber = widget.serialNumber;

    if (serialNumber == null) return;

    // 서버로 말벌 탐지 활성화/비활성화 상태 전달
    final url = Uri.parse('http://kulbul.iptime.org:8000/sensor/activate');

    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',  // 전달받은 토큰 사용
      },
      body: jsonEncode({
        'SN': serialNumber,
        'operate': isDetecting,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('탐지 요청 성공: ${responseData['message']}');
    } else {
      final responseData = jsonDecode(response.body);
      print('탐지 요청 실패: ${response.statusCode}');
      print('Error message: ${responseData['message']}');
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
            '${widget.camName} 실시간',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // IP 주소가 null일 때는 로딩 인디케이터를 보여줍니다.
              _ipAddress == null
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Screenshot(
                controller: _screenshotController,
                child: Container(
                  height: 300,
                  child: WebView(
                    initialUrl: 'http://$_ipAddress:5000/video_feed',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  height: 400,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    children: [
                      GridButton(
                        icon: isRecording
                            ? Icons.stop_circle_outlined
                            : Icons.video_camera_back_outlined,
                        label: isRecording ? '녹화 중지' : '녹화 시작',
                        onTap: () {
                          isRecording ? _stopRecording() : _startRecording();
                        },
                      ),
                      GridButton(
                        icon: Icons.camera_enhance_outlined,
                        label: '캡쳐',
                        onTap: _captureScreenshot,
                      ),
                      GridButton(
                        icon: isDetecting
                            ? Icons.start
                            : Icons.stop,
                        label: isDetecting ? '말벌 탐지 시작' : '말벌 탐지 중지',
                        onTap: _toggleDetector,
                      ),
                      GridButton(
                        icon: isCollectorOpen
                            ? Icons.close
                            : Icons.open_with,
                        label: isCollectorOpen ? '포집기 닫기' : '포집기 열기',
                        onTap: _toggleCollector,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _startRecording() async {
    try {
      const platform = MethodChannel('your.channel.name/foreground_service');
      await platform.invokeMethod('startForegroundService');

      bool start = await FlutterScreenRecording.startRecordScreen("Recording", titleNotification: "녹화 중", messageNotification: "화면을 녹화하고 있습니다.");

      if (!start) {
        setState(() {
          isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('녹화 시작 실패')),
        );
      } else {
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      setState(() {
        isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('녹화 도중 오류 발생: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await FlutterScreenRecording.stopRecordScreen;

      if (path != null) {
        // 지정된 경로로 파일 복사
        final directory = Directory('/storage/emulated/0/DCIM/honeycombo_Videos');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        String newFilePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.mp4';

        // 파일 복사
        File(path).copySync(newFilePath);

        setState(() {
          isRecording = false;
          _outputFilePath = newFilePath;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('녹화가 저장되었습니다: $_outputFilePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('녹화 중지 실패')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('녹화 도중 오류 발생: $e')),
      );
    }
  }

  Future<void> _captureScreenshot() async {
    final photoStatus = await Permission.photos.status;

    if (!photoStatus.isGranted) {
      final newStatus = await Permission.photos.request();
      if (!newStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진 권한이 필요합니다.')),
        );
        return;
      }
    }

    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = Directory('/storage/emulated/0/DCIM/honeycombo_Pictures');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      String fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = '${directory.path}/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스크린샷 저장됨: $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스크린샷 캡쳐 실패')),
      );
    }
  }

  void _toggleDetector() {
    setState(() {
      isDetecting = !isDetecting;
    });
    _detectorActiveRequest();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isDetecting ? '말벌 탐지를 시작합니다.' : '말벌 탐지를 중지합니다.'),
      ),
    );
  }

  void _toggleCollector() {
    setState(() {
      isCollectorOpen = !isCollectorOpen;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCollectorOpen ? '포집기 열림' : '포집기 닫힘'),
      ),
    );
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
      child: Card(
        color: whiteMyStyle1, // 원하는 배경색 적용
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0), // 내부 패딩 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로축 중앙 정렬
            children: [
              Icon(
                icon,
                color: yelloMyStyle1, // 원하는 아이콘 색상 적용
                size: 40, // 아이콘 크기
              ),
              SizedBox(height: 8), // 아이콘과 텍스트 사이의 간격
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'PretendardBold'
                ), // 텍스트 스타일
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
              ),
            ],
          ),
        ),
      ),
    );
  }
}
