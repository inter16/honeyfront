import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/states/camera_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../states/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationDetails details = const NotificationDetails(
    android: AndroidNotificationDetails(
      "show_test",
      "show_test",
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  void _showNotification() async {
    await _local.show(
      0,
      "타이틀이 보여지는 영역입니다.",
      "컨텐츠 내용이 보여지는 영역입니다.\ntest show()",
      details,
      payload: "tyger://",
    );
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  void _initialization() async {
    AndroidInitializationSettings android =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings settings = InitializationSettings(android: android);
    await _local.initialize(settings);
  }

  @override
  void initState() {
    super.initState();
    _permissionWithNotification();
    _initialization();
    _loadCameraList(); // 카메라 목록 로드
  }

  void _loadCameraList() async {
    final token = Provider.of<AuthProvider>(context, listen: false).accessToken;
    if (token != null && token.isNotEmpty) {
      final cameras = await camListRequest(token);
      if (mounted) {
        Provider.of<CameraProvider>(context, listen: false).setCameras(cameras);
      }
    }
  }

  Future<List<Map<String, String>>> camListRequest(String token) async {
    final url = Uri.parse('http://kulbul.iptime.org:8000/sensor');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('요청 성공: ${utf8.decode(response.bodyBytes)}');
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        List<Map<String, String>> cameraList = [];
        data.forEach((key, value) {
          cameraList.add({
            'serialNumber': key,
            'cameraName': value,
          });
        });

        return cameraList;
      } else if (response.statusCode == 403) {
        print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
        await Provider.of<AuthProvider>(context, listen: false).logout();
        context.go('/login'); // 로그인 페이지로 리디렉션
        throw Exception('Failed to load camera list. Status code: 403');
      } else {
        print('요청 실패: ${response.statusCode}');
        throw Exception('Failed to load camera list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 중 오류 발생: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: ClearMyStyle1,
          title: Text(
            '내 양봉장 확인하기',
            style: TextStyle(
              fontFamily: 'PretendardBold',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                final cameraList = Provider.of<CameraProvider>(context, listen: false).cameras;
                context.push('/register', extra: cameraList);
              },
              icon: Icon(
                Icons.add,
                color: yelloMyStyle1,
                size: 42,
              ),
            ),
          ],
        ),
        body: Consumer<CameraProvider>(
          builder: (context, cameraProvider, child) {
            final cameraList = cameraProvider.cameras;
            if (cameraList.isEmpty) {
              return NoProductsWidget(
                onRegister: () {
                  context.push('/register', extra: cameraList);
                },
              );
            } else {
              return ProductsListWidget(
                cameraList: cameraList,
                onRegister: () {
                  context.push('/register', extra: cameraList);
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/imagelog');
            // _showNotification();
          }, // 카메라 목록 재로드
          backgroundColor: yelloMyStyle1,
          child: Icon(Icons.history),
        ),
      ),
    );
  }
}

class NoProductsWidget extends StatelessWidget {
  final VoidCallback onRegister;

  const NoProductsWidget({required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '등록된 카메라가 없습니다.',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Container(
            width: 160,
            height: 50,
            child: ElevatedButton(
              onPressed: onRegister,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: yelloMyStyle1,
                foregroundColor: blackMyStyle1,
                padding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              child: const Text(
                '카메라 등록하기',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsListWidget extends StatelessWidget {
  final List<Map<String, String>> cameraList;
  final VoidCallback onRegister;

  const ProductsListWidget({
    required this.cameraList,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cameraList.length,
              itemBuilder: (context, index) {
                final camera = cameraList[index];
                return Card(
                  color: whiteMyStyle1, // 카드 배경색을 지정합니다.
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: yelloMyStyle1, // 아이콘 색상을 지정합니다.
                      size: 36, // 아이콘 크기를 지정합니다.
                    ),
                    title: Text(
                      camera['cameraName'] ?? 'Unknown',
                      style: const TextStyle(fontSize: 18), // 제목 텍스트 스타일 지정
                    ),
                    subtitle: Text(
                      'SN: ${camera['serialNumber'] ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey), // 부제목 텍스트 스타일 지정
                    ),
                    onTap: () {
                      context.push('/stream', extra: {
                        'serialNumber': camera['serialNumber'],
                        'cameraName': camera['cameraName'],
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

  }
}
