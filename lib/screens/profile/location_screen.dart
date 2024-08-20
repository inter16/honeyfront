import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/states/auth_provider.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void getLocRequest(BuildContext context, void Function(String?) onLocLoaded) async {
  final url = Uri.parse('http://kulbul.iptime.org:8000/user/getinfo');

  try {
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final decodedJson = jsonDecode(responseBody);
      final loc = decodedJson['loc'];
      print(decodedJson);

      onLocLoaded(loc); // loc 값이 null이든 값이 있든 전달
    } else if (response.statusCode == 400) {
      print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
      await Provider.of<AuthProvider>(context, listen: false).logout();
      context.go('/login');
    }
  } catch (e) {
    print('Error: $e');
    onLocLoaded(null);
  }
}

void editLocRequest(BuildContext context, String loc, void Function(String) onLocEdited) async {
  final url = Uri.parse('http://kulbul.iptime.org:8000/user/edit');

  try {
    final response = await http.patch(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',
      },
      body: jsonEncode({
        'loc': loc,
      }),
    );

    if (response.statusCode == 200) {
      onLocEdited(loc); // 수정 성공 후 콜백 호출
      context.pop();
    } else if (response.statusCode == 400) {
      print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
      await Provider.of<AuthProvider>(context, listen: false).logout();
      context.go('/login');
    }
  } catch (e) {
    print('Error: $e');
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // 시도명과 시도 코드를 JSON 형식으로 정의
  final List<Map<String, String>> sidoList = [
    {'sidoCode': '11', 'sidoName': '서울특별시'},
    {'sidoCode': '21', 'sidoName': '부산광역시'},
    {'sidoCode': '22', 'sidoName': '대구광역시'},
    {'sidoCode': '23', 'sidoName': '인천광역시'},
    {'sidoCode': '24', 'sidoName': '광주광역시'},
    {'sidoCode': '25', 'sidoName': '대전광역시'},
    {'sidoCode': '26', 'sidoName': '울산광역시'},
    {'sidoCode': '29', 'sidoName': '세종특별자치시'},
    {'sidoCode': '31', 'sidoName': '경기도'},
    {'sidoCode': '32', 'sidoName': '강원도'},
    {'sidoCode': '33', 'sidoName': '충청북도'},
    {'sidoCode': '34', 'sidoName': '충청남도'},
    {'sidoCode': '35', 'sidoName': '전라북도'},
    {'sidoCode': '36', 'sidoName': '전라남도'},
    {'sidoCode': '37', 'sidoName': '경상북도'},
    {'sidoCode': '38', 'sidoName': '경상남도'},
    {'sidoCode': '39', 'sidoName': '제주특별자치도'},
  ];

  String? selectedSidoCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // 처음 로드될 때 위치 정보를 가져옴
    getLocRequest(context, (loc) {
      setState(() {
        selectedSidoCode = loc; // null이 올 수도 있음
        isLoading = false;
      });
    });
  }

  // 로딩이 끝난 후 위치 선택 UI를 보여주는 위젯
  Widget buildLocationSelection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: whiteMyStyle1,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sidoList.length,
          itemBuilder: (context, index) {
            final sido = sidoList[index];
            return RadioListTile<String>(
              title: Text(sido['sidoName']!),
              value: sido['sidoCode']!,
              groupValue: selectedSidoCode, // 선택된 값이 없으면 null 상태 유지
              onChanged: (value) {
                setState(() {
                  selectedSidoCode = value; // 선택된 시도 코드 업데이트
                });
              },
              activeColor: yelloMyStyle1,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yelloMyStyle2,
      appBar: AppBar(
        backgroundColor: whiteMyStyle1,
        title: const Text(
          '양봉장 위치 선택',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 데이터 로딩 중 표시
          : SingleChildScrollView( // 선택 화면 스크롤 가능하게 설정
        child: buildLocationSelection(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50.0,
          child: TextButton(
            onPressed: () {
              if (selectedSidoCode != null) {
                // 선택된 시도 코드 서버에 전송
                editLocRequest(context, selectedSidoCode!, (newLoc) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('위치 정보가 업데이트되었습니다: $newLoc')),
                  );
                });
              } else {
                // 선택된 시도 코드가 없는 경우
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('위치를 선택해주세요.')),
                );
              }
            },
            child: const Text(
              '완료',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: yelloMyStyle1,
              foregroundColor: blackMyStyle1,
            ),
          ),
        ),
      ),
    );
  }
}
