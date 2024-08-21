import 'package:flutter/material.dart';
import 'package:front/screens/starts/intro_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:front/theme/colors.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:provider/provider.dart';
import '../states/auth_provider.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AnimatedSplashScreen(
          duration: 5000, // 5초 동안 애니메이션 유지
          splash: _BeeAnimation(), // 벌처럼 움직이는 애니메이션 위젯
          nextScreen: authProvider.isLoggedIn ? HomeScreen() : IntroScreen(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: yelloMyStyle2,
          splashIconSize: 120, // 애니메이션의 크기
        );
      },
    );
  }
}

class _BeeAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        // X축: 오른쪽 하단에서 중앙으로 이동 (300에서 0으로)
        final double xOffset = 300 * (1 - value); // 오른쪽에서 중앙으로
        // Y축: 하단에서 상단으로 이동 (300에서 -150으로)
        final double yOffset = 300 * (1 - value) - 190; // 하단에서 상단으로

        return Transform.translate(
          offset: Offset(xOffset, yOffset),
          child: Opacity(
            opacity: value, // 투명도 변화 (서서히 나타남)
            child: Image.asset('assets/images/logo.png'),
          ),
        );
      },
    );
  }
}