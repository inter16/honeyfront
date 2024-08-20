import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';

class AlarmScreen extends StatefulWidget {
  AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // 알림 데이터 리스트 예시
  List<Map<String, String>> alarmList = [
    {
      'title': '말벌 5마리 감지',
      'date': '2024-08-16',
    },
    {
      'title': '말벌 15마리 감지',
      'date': '2024-08-15',
    },
    {
      'title': '말벌 25마리 감지',
      'date': '2024-08-14',
    },
    {
      'title': '말벌 35마리 감지',
      'date': '2024-08-13',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: whiteMyStyle1,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  context.push('/alarmsetting');
                },
                icon: Icon(
                  Icons.settings,
                  color: yelloMyStyle1,
                  size: 36,
                )),
          ],
          title: const Text(
            '알림',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        body: alarmList.isEmpty
            ? const NoAlarmWidget() // 알림이 없을 때
            : AlarmListWidget(
          alarmList: alarmList,
          onDelete: (index) {
            setState(() {
              alarmList.removeAt(index);
            });
          },
        ), // 알림이 있을 때 리스트 출력
      ),
    );
  }
}

// 알림이 없을 때 보여줄 위젯
class NoAlarmWidget extends StatelessWidget {
  const NoAlarmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '알림이 없습니다.',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black54,
        ),
      ),
    );
  }
}

// 알림 리스트를 보여줄 위젯
class AlarmListWidget extends StatelessWidget {
  final List<Map<String, String>> alarmList;
  final Function(int) onDelete;

  const AlarmListWidget({
    super.key,
    required this.alarmList,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: alarmList.length,
      itemBuilder: (context, index) {
        final alarm = alarmList[index];
        return Dismissible(
          key: Key(alarm['title']!),
          direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 밀기
          onDismissed: (direction) {
            // 스와이프 시 삭제 동작
            onDelete(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${alarm['title']} 삭제됨")),
            );
          },
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerRight,
            color: Colors.transparent, // 배경을 투명하게 하고,
            child: Container(
              height: 50.0, // 기존 ListTile보다 낮은 높이 설정
              width: double.infinity,
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          child: Card(
            color: whiteMyStyle1,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(
                Icons.notification_important,
                color: yelloMyStyle1,
                size: 36,
              ),
              title: Text(
                alarm['title']!,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                alarm['date']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              onTap: () {
                // 알림 항목 클릭 시 동작 정의
              },
            ),
          ),
        );
      },
    );
  }
}
