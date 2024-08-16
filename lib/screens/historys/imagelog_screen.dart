import 'package:flutter/material.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';

class ImagelogScreen extends StatefulWidget {
  ImagelogScreen({super.key});

  @override
  State<ImagelogScreen> createState() => _ImagelogScreenState();
}

class _ImagelogScreenState extends State<ImagelogScreen> {
  final List<Map<String, dynamic>> imageLog = [
    {'image': 'assets/images/bee.jpg', 'time': '2024-08-14 12:34:56'},
    {'image': 'assets/images/bee.jpg', 'time': '2024-08-14 14:20:00'},
  ];

  void _showImageDialog(BuildContext context, String imagePath, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // actionsPadding: EdgeInsets.only(bottom: 8),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Text(
                        time,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Center(
                child: Text(
                  '닫기',
                  style: TextStyle(
                    color: blackMyStyle2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '히스토리 확인',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        body: imageLog.isEmpty
            ? const NoHistoryWidget()
            : HistoryListWidget(
          imageLog: imageLog,
          onImageTap: _showImageDialog,
        ),
      ),
    );
  }
}

class NoHistoryWidget extends StatelessWidget {
  const NoHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: yelloMyStyle2,
      child: const Center(
        child: Text(
          '히스토리가 없습니다.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class HistoryListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> imageLog;
  final Function(BuildContext, String, String) onImageTap;

  const HistoryListWidget({
    required this.imageLog,
    required this.onImageTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: yelloMyStyle2,
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: imageLog.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 160, // 너비 조정
              height: 90, // 높이 조정
              child: Image.asset(
                imageLog[index]['image'],
                fit: BoxFit.fill,
              ),
            ),
            title: Text(imageLog[index]['time']),
            onTap: () {
              onImageTap(
                context,
                imageLog[index]['image'],
                imageLog[index]['time'],
              );
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: yelloMyStyle1,
        ),
      ),
    );
  }
}
