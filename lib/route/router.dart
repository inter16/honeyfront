import 'package:flutter/material.dart';
import 'package:front/screens/historys/analysis_screen.dart';
import 'package:front/screens/historys/imagelog_screen.dart';
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

GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) {
        // 자동 로그인 여부에 따라 초기 화면 결정
        return authProvider.isLoggedIn
            ? const BottomScreen() // 로그인 상태일 경우 메인 화면
            : const IntroScreen(); // 로그아웃 상태일 경우 소개 화면
      }),
      GoRoute(path: '/intro', builder: (context, state) => const IntroScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          // extra를 통해 전달된 데이터가 List<Map<String, String>>인지 확인하고, null safety 처리
          final cameraList = state.extra as List<Map<String, String>>? ?? [];
          return RegisterScreen(cameras: cameraList);
        },
      ),

      GoRoute(
        path: '/stream',
        builder: (context, state) {
          final camName = state.extra as String?;
          return StreamingScreen(camName: camName);
        },),
      // GoRoute(path: '/myprofile', builder: (context, state) => MyprofileScreen()),
      GoRoute(path: '/imagelog', builder: (context, state) => ImagelogScreen()),
      GoRoute(path: '/analysis', builder: (context, state) => AnalysisScreen()),
      GoRoute(path: '/location', builder: (context, state) => LocationScreen()),
    ],
    redirect: (context, state) {
      final location = state.uri.toString();
      final isLoggingIn = location == '/login' || location == '/signup';
      if (!authProvider.isLoggedIn && !isLoggingIn) return '/intro';
      if (authProvider.isLoggedIn && location == '/intro') return '/';
      return null;
    },
  );
}

