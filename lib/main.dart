import 'package:flutter/material.dart';
import 'package:front/screens/bottom_screen.dart';
import 'package:front/screens/home/register_screen.dart';
import 'package:front/screens/profile/myprofile_screen.dart';
import 'package:front/screens/starts/intro_screen.dart';
import 'package:front/screens/starts/login_screen.dart';
import 'package:front/screens/starts/signup_screen.dart';
import 'package:front/streaming_screen.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const BottomScreen()),
    GoRoute(path: '/intro', builder: (context, state) => const IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: '/stream',
      builder: (context, state) {
        final camName = state.extra as String?;
        return StreamingScreen(camName: camName);
        },),

    GoRoute(path: '/myprofile', builder: (context, state) => MyprofileScreen()),
  ]
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      routerConfig: _router,
    );
  }

}