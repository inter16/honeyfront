import 'package:flutter/material.dart';
import 'package:front/screens/historys/analysis_screen.dart';
import 'package:front/screens/home/home_screen.dart';
import 'package:front/screens/profile/profile_screen.dart';
import 'package:front/theme/colors.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {

  int _bottomSelectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AnalysisScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yelloMyStyle2,
      body: _screens[_bottomSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });

        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label:'내 양봉장'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label:'분석'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:'프로필'),
        ],
      ),
    );
  }
}
