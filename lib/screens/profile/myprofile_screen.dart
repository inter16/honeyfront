import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';

class MyprofileScreen extends StatelessWidget {
  const MyprofileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteMyStyle1,
        title: Text(
          '프로필',
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.orange,
      ),
    );
  }
}
