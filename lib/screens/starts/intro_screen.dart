import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

                  Text(
                    '꿀벌방범대 소개 글 ~ \n꿀벌방범대 소개 글 ~ \n꿀벌방범대 소개 글 ~ ',
                    style: TextStyle(
                      fontFamily: 'PretendardBold',
                      fontSize: 30,
                    ),
                  ),

                  SizedBox(height: 48.0,),

                  Container(
                    width: 320, height: 50,
                    child: TextButton(
                      onPressed: () => context.push('/login'),
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
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8.0,),
                  
                  Text(
                    '혹은'
                  ),

                  SizedBox(height: 8.0,),

                  Container(
                    width: 320, height: 50,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        backgroundColor: kakaoColor,
                        foregroundColor: blackMyStyle1,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      child: Text(
                        '카카오로 시작하기',
                        style: TextStyle(
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 144.0,),
                  
                  Text(
                    '계정이 없으신가요?',
                    style: TextStyle(
                      color: blackMyStyle2,
                    ),
                  ),
                  
                  SizedBox(height: 8.0,),

                  Container(
                    width: 320, height: 50,
                    child: TextButton(
                      onPressed: () => context.push('/signup'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        backgroundColor: blackMyStyle2,
                        foregroundColor: whiteMyStyle1,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      child: Text(
                        '핸드폰 번호로 가입하기',
                        style: TextStyle(
                          fontFamily: 'PretendardBold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
