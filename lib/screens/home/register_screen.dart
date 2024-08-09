import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리할 키
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  int _cameraCount = 1; // 카메라 이름 자동 생성에 사용할 카운트

  List<Map<String, String>> _registeredCameras = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        width: 100, height: 50,
                        child: ElevatedButton(
                          onPressed: _registerCamera,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
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
            SizedBox(height: 24.0,),

            Container(
              height: 1.0,
              color: yelloMyStyle1,
            ),

            SizedBox(height: 24.0,),

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
              child: Container(
                child: Text('여기에 카메라 목록 불러오기'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerCamera() {
    if (_formKey.currentState!.validate()) {
      String serialNumber = _serialNumberController.text;
      String name = _nameController.text.trim();

      if (name.isEmpty) {
        name = 'Cam$_cameraCount';
        _cameraCount++; // 다음 카메라 이름을 위해 카운트 증가
      }

      // 시리얼 번호와 이름 출력 (또는 서버에 전송)
      print('등록된 카메라 시리얼 번호: $serialNumber');
      print('등록된 카메라 이름: $name');

      // 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카메라가 성공적으로 등록되었습니다: $name')),
      );

      // 입력 필드 초기화
      _serialNumberController.clear();
      _nameController.clear();
    }
  }
}
