import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front/route/router.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'states/auth_provider.dart';
import 'states/camera_provider.dart';

//디버그 해시 값
// wsF5gRLz/gfAuVdbpLMgZv2uHGs


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  // KakaoSdk.init(
  //   nativeAppKey: '9e6c07a96429e065ae18309132c74a9e',
  //   javaScriptAppKey: '0e255737a245c2acadecc73750f737ca',
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'PretendardRegular',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: yelloMyStyle1,
          unselectedItemColor: blackMyStyle2,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(context), // 분리된 라우터 설정을 사용,
    );
  }

}