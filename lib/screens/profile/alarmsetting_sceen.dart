import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  _AlarmSettingScreenState createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  bool isAlarmEnabled = true;
  bool isDoNotDisturbEnabled = false;
  bool isSystemNotificationEnabled = true; // 시스템 푸시 알림 사용 여부
  TimeOfDay startDoNotDisturbTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay endDoNotDisturbTime = const TimeOfDay(hour: 7, minute: 0);

  // 방해 금지 시간 선택 함수
  Future<void> selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startDoNotDisturbTime : endDoNotDisturbTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: yelloMyStyle1, // 시계의 강조 색상
              onPrimary: Colors.black, // 텍스트 색상
              surface: whiteMyStyle1, // 다이얼 배경색
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: yelloMyStyle1, // 버튼 텍스트 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDoNotDisturbTime = picked;
        } else {
          endDoNotDisturbTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: whiteMyStyle1,
          centerTitle: true,
          title: const Text(
            '알림 설정',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 알림 사용 여부 스위치
            Container(
              decoration: BoxDecoration(
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
              ),
              child: SwitchListTile(
                title: const Text(
                  '알림 사용',
                  style: TextStyle(fontSize: 16),
                ),
                activeColor: yelloMyStyle1,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
                value: isAlarmEnabled,
                onChanged: (bool value) {
                  setState(() {
                    isAlarmEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),

            // 방해 금지 모드 사용 여부 스위치
            Container(
              decoration: BoxDecoration(
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
              ),
              child: SwitchListTile(
                title: const Text(
                  '방해 금지 모드 사용',
                  style: TextStyle(fontSize: 16),
                ),
                activeColor: yelloMyStyle1,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
                value: isDoNotDisturbEnabled,
                onChanged: (bool value) {
                  setState(() {
                    isDoNotDisturbEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),

            // 방해 금지 시간 설정
            Container(
              decoration: BoxDecoration(
                color: isDoNotDisturbEnabled ? whiteMyStyle1 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text(
                  '방해 금지 시간 설정',
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                    '시작: ${startDoNotDisturbTime.format(context)} - 종료: ${endDoNotDisturbTime.format(context)}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                enabled: isDoNotDisturbEnabled,
                onTap: isDoNotDisturbEnabled
                    ? () async {
                  await selectTime(context, true);
                  await selectTime(context, false);
                }
                    : null,
              ),
            ),
            const SizedBox(height: 16.0),

            // 시스템 알림 (푸시 알림) 사용 여부 스위치
            // Container(
            //   decoration: BoxDecoration(
            //     color: whiteMyStyle1,
            //     borderRadius: BorderRadius.circular(10.0),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 5,
            //         offset: const Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: SwitchListTile(
            //     title: const Text(
            //       '시스템 알림 사용',
            //       style: TextStyle(fontSize: 16),
            //     ),
            //     activeColor: yelloMyStyle1,
            //     inactiveThumbColor: Colors.grey,
            //     inactiveTrackColor: Colors.grey.shade400,
            //     value: isSystemNotificationEnabled,
            //     onChanged: (bool value) {
            //       setState(() {
            //         isSystemNotificationEnabled = value;
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
