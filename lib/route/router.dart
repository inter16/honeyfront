import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/historys/analysis_screen.dart';
import 'package:front/screens/historys/imagelog_screen.dart';
import 'package:front/screens/profile/alarm_screen.dart';
import 'package:front/screens/profile/alarmsetting_sceen.dart';
import 'package:front/screens/profile/setting_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../states/auth_provider.dart';
import '../screens/bottom_screen.dart';
import '../screens/home/register_screen.dart';
import '../screens/profile/location_screen.dart';
import '../screens/starts/intro_screen.dart';
import '../screens/starts/login_screen.dart';
import '../screens/starts/signup_screen.dart';
import '../screens/home/streaming_screen.dart';

// 글로벌 NavigatorKey 추가
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    navigatorKey: navigatorKey,  // navigatorKey 설정
    initialLocation: '/',
    refreshListenable: authProvider,  // AuthProvider의 상태 변화를 감지하여 라우트가 자동으로 갱신되도록 설정
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return authProvider.isLoggedIn
              ? const BottomScreen()  // 로그인 상태일 경우 메인 화면
              : const IntroScreen();  // 로그아웃 상태일 경우 소개 화면
        },
      ),
      GoRoute(path: '/intro', builder: (context, state) => const IntroScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final cameraList = state.extra as List<Map<String, String>>? ?? [];
          return RegisterScreen(cameras: cameraList);
        },
      ),
      GoRoute(
        path: '/stream',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final cameraName = extra['cameraName'];
          final serialNumber = extra['serialNumber'];

          return StreamingScreen(
            camName: cameraName,
            serialNumber: serialNumber,
          );
        },
      ),
      GoRoute(path: '/imagelog', builder: (context, state) => ImagelogScreen()),
      GoRoute(path: '/analysis', builder: (context, state) => AnalysisScreen()),
      GoRoute(path: '/setting', builder: (context, state) => SettingScreen()),
      GoRoute(path: '/location', builder: (context, state) => LocationScreen()),
      GoRoute(path: '/alarm', builder: (context, state) => AlarmScreen()),
      GoRoute(path: '/alarmsetting', builder: (context, state) => AlarmSettingScreen()),
    ],
    redirect: (context, state) {
      final location = state.uri.toString();
      final isLoggingIn = location == '/login' || location == '/signup';

      // 로그인되지 않은 상태에서 보호된 경로로 접근하려 할 때 리다이렉트
      if (!authProvider.isLoggedIn && !isLoggingIn) return '/intro';

      // 이미 로그인된 상태에서 intro 화면에 접근하려 할 때 리다이렉트
      if (authProvider.isLoggedIn && location == '/intro') return '/';

      return null; // 리다이렉트가 필요하지 않은 경우
    },
  );
}

// 알림 클릭 시 특정 화면으로 이동
void _navigateToNotificationScreen(RemoteMessage message) {
  navigatorKey.currentState?.pushNamed('/imagelog');
}
