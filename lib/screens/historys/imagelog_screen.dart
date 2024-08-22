import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/states/auth_provider.dart';
import 'package:front/theme/box_decoration.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ImagelogScreen extends StatefulWidget {
  ImagelogScreen({super.key});

  @override
  State<ImagelogScreen> createState() => _ImagelogScreenState();
}

class _ImagelogScreenState extends State<ImagelogScreen> {
  List<Map<String, dynamic>> imageLog = [];

  @override
  void initState() {
    super.initState();
    getImageLogRequest(context);
  }

  void getImageLogRequest(BuildContext context) async {
    final url = Uri.parse('http://kulbul.iptime.org:8000/user/images');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        List<Map<String, dynamic>> fetchedImageLog = [];

        // Parse the response data
        responseData.forEach((time, details) {
          // Parse the DateTime
          DateTime parsedDateTime = DateTime.parse(time);
          String formattedDate = "${parsedDateTime.year}-${parsedDateTime.month.toString().padLeft(2, '0')}-${parsedDateTime.day.toString().padLeft(2, '0')}";
          String formattedTime = "${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}";

          fetchedImageLog.add({
            'sn': details[0], // Sensor name
            'image': details[1], // Image URL
            'date': formattedDate, // Date in yyyy-MM-dd format
            'time': formattedTime, // Time in HH:mm format
          });
        });

        setState(() {
          imageLog = fetchedImageLog;
        });
      } else if (response.statusCode == 400) {
        print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
        await Provider.of<AuthProvider>(context, listen: false).logout();
        context.go('/login');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blackMyStyle2, // 배경을 검은색으로 설정
          insetPadding: EdgeInsets.zero, // 기본 여백을 제거하여 전체 화면으로 확장
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(), // 탭 시 다이얼로그 닫기
                child: Center(
                  child: InteractiveViewer( // 이미지 확대 및 이동 가능
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain, // 화면에 맞게 이미지를 표시하면서 비율 유지
                      width: double.infinity,
                      height: double.infinity,
                      // 둥근 모서리 제거 - borderRadius 및 ClipRRect 사용하지 않음
                    ),
                  ),
                ),
              ),
              // 닫기 버튼
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: whiteMyStyle1, size: 30),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
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
  final Function(BuildContext, String) onImageTap;

  const HistoryListWidget({
    required this.imageLog,
    required this.onImageTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: yelloMyStyle2,
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: imageLog.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Add rounded corners
            ),
            elevation: 4, // Add a shadow effect to the card
            child: InkWell(
              onTap: () {
                onImageTap(
                  context,
                  imageLog[index]['image'],
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
                      child: Image.network(
                        imageLog[index]['image'],
                        height: 200, // Adjust the image height
                        width: double.infinity, // Full width of the card
                        fit: BoxFit.cover, // Cover the entire container
                      ),
                    ),
                    const SizedBox(height: 12), // Spacing between the image and text
                    Row(
                      children: [
                        Text(
                          "[${imageLog[index]['sn']}]", // Display sensor name
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'PretendardBold',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          imageLog[index]['date'], // Display date
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'PretendardSemiBold',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          imageLog[index]['time'], // Display time
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
