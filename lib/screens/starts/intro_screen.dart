import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: yelloMyStyle2,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 144.0),

                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),

                      // const SizedBox(height: 144.0),
                      //

                      const SizedBox(height: 188.0),

                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: yelloMyStyle1,
                            foregroundColor: blackMyStyle1,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          child: const Text(
                            '로그인 하기',
                            style: TextStyle(
                              fontFamily: 'PretendardBold',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      const Text('혹은'),

                      const SizedBox(height: 8.0),

                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: kakaoColor,
                            foregroundColor: blackMyStyle1,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          child: const Text(
                            '카카오로 시작하기',
                            style: TextStyle(
                              fontFamily: 'PretendardBold',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 72.0),

                      const Text(
                        '계정이 없으신가요?',
                        style: TextStyle(
                          color: blackMyStyle2,
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => context.push('/signup'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: blackMyStyle2,
                            foregroundColor: whiteMyStyle1,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          child: const Text(
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
          ),
        ),
      ),
    );
  }
}
