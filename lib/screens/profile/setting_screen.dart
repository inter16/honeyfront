import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSoundOn = true; // Initial state of the sound toggle

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: whiteMyStyle1,
          centerTitle: true,
          title: const Text(
            '설정',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Container(
                decoration: SettingBoxDecoration(),
                child: Column(
                  children: <Widget>[
                    // Directly adding the switch with custom design for '소리'
                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     color: whiteMyStyle1,
                    //   ),
                    //   child: Center(
                    //     child: ListTile(
                    //       title: const Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: Text(
                    //           '소리',
                    //           style: TextStyle(
                    //               fontFamily: 'Pretendard', fontSize: 16.0),
                    //         ),
                    //       ),
                    //       trailing: Switch(
                    //         value: isSoundOn,
                    //         activeColor: yelloMyStyle1,
                    //         inactiveThumbColor: Colors.grey,
                    //         inactiveTrackColor: Colors.grey.shade400,
                    //         onChanged: (bool value) {
                    //           setState(() {
                    //             isSoundOn = value;
                    //           });
                    //           // Implement functionality to handle sound settings if needed
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16.0),
                    buildCustomListTile(
                      title: 'Push 알림',
                      onTap: () {
                        context.push('/alarmsetting');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: SettingBoxDecoration(),
                child: Column(
                  children: <Widget>[
                    buildCustomListTile(
                      title: '앱 정보',
                      onTap: () {},
                    ),
                    buildCustomListTile(
                      title: '개인정보 사용 권한 설정',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCustomListTile({
  required String title,
  required VoidCallback onTap,
  Widget? trailing,
  double leadingIconSize = 30.0,
  double trailingIconSize = 20.0,
  TextStyle? titleStyle,
}) {
  return Container(
    height: 50,
    child: Center(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: titleStyle ?? const TextStyle(fontFamily: 'Pretendard', fontSize: 16.0),
          ),
        ),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: trailingIconSize),
        onTap: onTap,
      ),
    ),
  );
}

BoxDecoration SettingBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: whiteMyStyle1,
  );
}
