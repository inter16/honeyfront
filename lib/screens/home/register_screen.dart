import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../states/camera_provider.dart';
import '../../theme/colors.dart';
import '../../states/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final List<Map<String, String>> cameras; // 카메라 목록을 받는 변수

  RegisterScreen({required this.cameras});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리할 키
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late int _cameraCount; // 카메라 이름 자동 생성에 사용할 카운트

  @override
  void initState() {
    super.initState();
    _cameraCount = widget.cameras.length + 1; // 카메라 목록의 개수를 기준으로 카운트 설정
  }

  void registerRequest(BuildContext context, String number, String name) async {
    // 요청을 보낼 URL
    final url = Uri.parse('http://kulbul.iptime.org:8000/sensor/register');

    // POST 요청
    final response = await http.patch(
      url,
      headers: {
        'accept': 'application/json', // 응답 헤더 설정
        'Content-Type': 'application/json', // 요청 헤더 설정
        'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}', // 엑세스 토큰 추가
      },
      body: jsonEncode({
        'SN': number, // 폼 데이터
        'name': name, // 폼 데이터
      }),
    );

    // 응답 처리
    if (response.statusCode == 201) {
      print('카메라 등록 성공: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카메라가 성공적으로 등록되었습니다.')),
      );

      // Provider를 통해 HomeScreen의 상태를 업데이트
      Provider.of<CameraProvider>(context, listen: false).addCamera({
        'serialNumber': number,
        'cameraName': name,
      });

      setState(() {
        widget.cameras.add({
          'serialNumber': number,
          'cameraName': name,
        }); // 새로 등록된 카메라를 목록에 추가
      });
      // 입력 필드 초기화
      _serialNumberController.clear();
      _nameController.clear();
    } else if (response.statusCode == 400) {
      print('엑세스 토큰 오류: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('엑세스 토큰 오류: 다시 로그인하세요.')),
      );
    } else if (response.statusCode == 404) {
      print('카메라 시리얼 번호를 찾을 수 없음: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카메라 시리얼 번호를 찾을 수 없습니다.')),
      );
    } else if (response.statusCode == 409) {
      print('이미 등록된 카메라: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 등록된 카메라입니다.')),
      );
    } else {
      print('카메라 등록 실패: ${response.statusCode}');
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카메라 등록 실패: ${response.statusCode}')),
      );
    }
  }

  void _registerCamera() {
    if (_formKey.currentState!.validate()) {
      String serialNumber = _serialNumberController.text;
      String name = _nameController.text.trim();

      if (name.isEmpty) {
        name = 'Cam$_cameraCount';
        _cameraCount++; // 다음 카메라 이름을 위해 카운트 증가
      }

      registerRequest(context, serialNumber, name); // 서버에 카메라 등록 요청
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          title: const Text(
            '카메라 등록',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 시리얼 번호 입력 필드
                    TextFormField(
                      controller: _serialNumberController,
                      decoration: InputDecoration(
                        labelText: '시리얼 번호 12자리 (필수)',
                        hintText: '123456789012',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blackMyStyle2),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '시리얼 번호는 필수입니다.';
                        }
                        if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                          return '숫자 12자를 입력하세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
      
                    // 이름 입력 필드
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: '카메라 이름 최대 20자 (선택)',
                        hintText: 'Cam1',
                        helperText: '이름은 미입력 시 자동으로 부여됩니다.',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blackMyStyle2),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                    ),
                    const SizedBox(height: 16.0),
      
                    // 등록 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _registerCamera,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: yelloMyStyle1,
                              foregroundColor: blackMyStyle1,
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                            ),
                            child: Text(
                              '등록하기',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
      
              Container(
                height: 1.0,
                color: yelloMyStyle1,
              ),
      
              SizedBox(height: 24.0),
      
              Container(
                height: 40.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '등록된 카메라',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'PretendardBold',
                  ),
                ),
              ),
              Expanded(
                child: widget.cameras.isEmpty
                    ? Center(
                  child: Text(
                    '등록된 카메라가 없습니다.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
                //     : ListView.builder(
                //   itemCount: widget.cameras.length,
                //   itemBuilder: (context, index) {
                //     final camera = widget.cameras[index];
                //     return ListTile(
                //       title: Text(camera['cameraName'] ?? 'Unknown'),
                //       subtitle: Text('SN: ${camera['serialNumber']}'),
                //       leading: Icon(Icons.camera_alt),
                //     );
                //   },
                // ),
                : ListView.builder(
                  itemCount: widget.cameras.length,
                  itemBuilder: (context, index) {
                    final camera = widget.cameras[index];
                    return Card(
                      color: whiteMyStyle1, // 카드 배경색 지정
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: yelloMyStyle1, // 아이콘 색상 지정
                          size: 36, // 아이콘 크기 지정
                        ),
                        title: Text(
                          camera['cameraName'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 18), // 제목 텍스트 스타일 지정
                        ),
                        subtitle: Text(
                          'SN: ${camera['serialNumber']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey), // 부제목 텍스트 스타일 지정
                        ),
                        onTap: () {
                          // 클릭 시 동작 정의
                        },
                      ),
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }



}
