import 'package:flutter/material.dart';
import 'package:front/screens/historys/analysis_screen.dart';
import 'package:front/screens/home/home_screen.dart';
import 'package:front/screens/news/news_screen.dart';
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
    NewsScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label:'내 양봉장'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label:'분석'),
          BottomNavigationBarItem(icon: Icon(Icons.local_post_office_outlined), label: '양봉 소식'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label:'프로필'),
        ],
      ),
    );
  }
}
