import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/route/router.dart';
import 'package:front/screens/splash_screen.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'states/auth_provider.dart';
import 'states/camera_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: '9e6c07a96429e065ae18309132c74a9e',
    javaScriptAppKey: '0e255737a245c2acadecc73750f737ca',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// 백그라운드 메시지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // notification이 있는 경우에만 푸시 알림 표시
  if (message.notification != null) {
    _showNotification(message);
  }
}

// 로컬 알림 설정
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
    _getToken();
  }

  // FCM 초기화
  void _initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 포그라운드 알림 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // notification이 있는 경우에만 푸시 알림 표시
      if (message.notification != null) {
        _showNotification(message);  // 포그라운드 상태에서도 푸시 알림 표시
      }
    });

    // 백그라운드에서 클릭 시 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('백그라운드에서 알림을 클릭했습니다: ${message.messageId}');
    });

    // 로컬 알림 초기화
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // FCM 토큰 가져오기
  void _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    setState(() {
      _fcmToken = token;
    });

    print('FCM 토큰: $_fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return MaterialApp.router(
            theme: ThemeData(
              fontFamily: 'PretendardRegular',
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: yelloMyStyle1,
                unselectedItemColor: blackMyStyle2,
                type: BottomNavigationBarType.fixed,
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: createRouter(context),  // navigatorKey는 router에 설정됨
          );
        }
      },
    );
  }

  // Firebase 및 기타 초기화 작업 처리
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
