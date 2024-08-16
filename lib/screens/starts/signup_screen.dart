import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;

void sendSignUpRequest(BuildContext context, id, pw, Function setError) async {
  // 요청을 보낼 URL
  final url = Uri.parse('http://kulbul.iptime.org:8000/user/signup');

  // POST 요청
  final response = await http.post(
    url,
    headers: {
      'accept': 'application/json', // 응답 헤더 설정
      'Content-Type': 'application/x-www-form-urlencoded', // 요청 헤더 설정
    },
    body: {
      'username': id, // 폼 데이터
      'password': pw, // 폼 데이터
    },
  );

  // 응답 처리
  if (response.statusCode == 201) {
    print('POST 요청 성공: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원 가입 성공했습니다!')),
    );
    // 회원가입 성공 시, 로그인 페이지로 이동
    context.go('/login');
  }
  else if (response.statusCode == 409) {
    print('POST 요청 실패: ${response.statusCode} - 핸드폰 번호 중복');
    setError('이미 사용 중인 번호입니다.');
  }
  else {
    print('POST 요청 실패: ${response.statusCode}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원 가입 실패: ${response.statusCode}')),
    );
  }
}

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  Color _suffixIconColor = blackMyStyle2;
  String? _phoneNumberError;


  // 핸드폰 번호 유효성 검사
  String? validatePhoneNumber(String? value) {
    if (_phoneNumberError != null) {
      return _phoneNumberError;
    }
    // 정규식을 사용하여 핸드폰 번호 형식을 검사합니다.
    if (value == null || !RegExp(r'^\d{11}$').hasMatch(value)) {
      return '올바른 핸드폰 번호를 입력하세요.';
    }
    return null;
  }

  // 핸드폰 번호 유효성 검사 및 실시간 아이콘 색상 업데이트
  void _validatePhoneNumber() {
    String input = _textEditingController.text;
    bool isValid = RegExp(r'^\d{11}$').hasMatch(input);

    setState(() {
      _suffixIconColor = isValid ? yelloMyStyle1 : blackMyStyle2;
    });
  }

  // 비밀번호 유효성 검사
  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-Z])(?=.*[0-9]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
    } else {
      return null; //null을 반환하면 정상
    }
  }

  // 비밀번호 일치 검사
  String? validatePasswordConfirm(String value) {
    if (value.isEmpty) {
      return '비밀번호 확인칸을 입력하세요';
    } else if (value != _passwordController.text) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null; // null을 반환하면 정상
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _setError(String? error) {
    setState(() {
      _phoneNumberError = error;
    });
    _formKey.currentState?.validate(); // Form 전체를 다시 검증하여 에러 표시
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ClearMyStyle1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150, height: 150,
                  ),

                  SizedBox(height: 36.0,),

                  Container(
                    width: 320, height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '회원가입 하기',
                      style: TextStyle(
                        fontFamily: 'PretendardBold',
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: 24.0,),

                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [MaskedInputFormatter('00000000000')],
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: _suffixIconColor,
                                ),
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: blackMyStyle2),
                                ),
                                hintText: '핸드폰 번호'
                            ),
                            validator: validatePhoneNumber,
                          ),

                          SizedBox(height: 8.0,),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: blackMyStyle2),
                                ),
                                hintText: '비밀번호'
                            ),
                            validator: (value) => validatePassword(value!),
                          ),

                          SizedBox(height: 8.0,),

                          TextFormField(
                            controller: _passwordConfirmController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: blackMyStyle2),
                                ),
                                hintText: '비밀번호 확인'
                            ),
                            validator: (value) => validatePasswordConfirm(value!),
                          ),

                          SizedBox(height: 32.0,),

                          Container(
                            width: 320, height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _phoneNumberError = null; // 오류 메시지 초기화
                                });
                                if (_formKey.currentState!.validate()) {
                                  // 폼이 유효하다면 회원가입을 진행합니다.
                                  sendSignUpRequest(
                                      context,
                                      _textEditingController.text,
                                      _passwordController.text,
                                      _setError);
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                backgroundColor: yelloMyStyle1,
                                foregroundColor: blackMyStyle1,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              child: Text(
                                '회원 가입하기',
                                style: TextStyle(
                                    fontFamily: 'PretendardBold'
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 72.0,),

                  Container(
                    width: 320, height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '꿀벌 방범대',
                      style: TextStyle(
                        fontFamily: 'PretendardBold',
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

