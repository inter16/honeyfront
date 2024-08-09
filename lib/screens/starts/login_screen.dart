import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Color _suffixIconColor = blackMyStyle2;

  // 임의로 유효한 핸드폰 번호와 비밀번호 설정
  final String _validPhoneNumber = "010-1234-5678";
  final String _validPassword = "qwer1234";

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 핸드폰 번호 유효성 검사
  String? validatePhoneNumber(String? value) {
    // 정규식을 사용하여 핸드폰 번호 형식을 검사합니다.
    if (value == null || !RegExp(r'^\d{3}-\d{4}-\d{4}$').hasMatch(value)) {
      return '올바른 핸드폰 번호를 입력하세요.';
    }
    return null;
  }

  // 비밀번호 유효성 검사
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요.';
    }
    return null;
  }

  void _validatePhoneNumber() {
    String input = _textEditingController.text;
    // 정규 표현식을 사용하여 핸드폰 번호 양식을 검사합니다.
    bool isValid = RegExp(r'^\d{3}-\d{4}-\d{4}$').hasMatch(input);

    setState(() {
      _suffixIconColor = isValid ? yelloMyStyle1 : blackMyStyle2; // 조건에 따라 색상 변경
    });
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // 입력된 핸드폰 번호와 비밀번호가 유효한 경우
      if (_textEditingController.text == _validPhoneNumber &&
          _passwordController.text == _validPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 성공!')),
        );
        context.go('/'); // 경로 이동
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('유효하지 않은 핸드폰 번호 또는 비밀번호입니다.')),
        );
      }
    }
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

                  SizedBox(height: 48.0,),

                  Container(
                    width: 320, height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '로그인 하기',
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
                            inputFormatters: [MaskedInputFormatter('000-0000-0000')],
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
                            validator: validatePassword,
                          ),

                          SizedBox(height: 32.0,),

                          Container(
                            width: 320, height: 50,
                            child: TextButton(
                              onPressed: () => _login(context),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                backgroundColor: yelloMyStyle1,
                                foregroundColor: blackMyStyle1,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              child: Text(
                                '로그인 하기',
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

                  SizedBox(height: 144.0,),

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
