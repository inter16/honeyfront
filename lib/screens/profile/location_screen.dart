import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteMyStyle1,
      ),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
