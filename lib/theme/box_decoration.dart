import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';

BoxDecoration containerBoxDecoration() {
  return BoxDecoration(
    color: whiteMyStyle1,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
}