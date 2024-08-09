import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: ClearMyStyle1,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: yelloMyStyle1,
                  size: 36,
                )
            ),
          ],
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                // height: 100,
                child: Center(
                  child: ListTile(
                    leading: Icon(Icons.face, size: 50.0,),
                    title: Text(
                      '이름을 입력해주세요.',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'PretendardBold'
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20.0,),
                    onTap: () {
                      context.push('/myprofile');
                    },
                  ),
                ),
              ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Container(
              //       width: 100, height: 100,
              //       child: Icon(
              //         Icons.face,
              //         size: 60,
              //       ),
              //     ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 250, height: 100,
                  //       color: blackMyStyle2,
                  //     ),
                  //     Container(
                  //       child: Icon(Icons.arrow_forward_ios),
                  //     )
                  //   ],
                  // ),
              //   ],
              // )
            ),

            SizedBox(height: 12.0,),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: whiteMyStyle1,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: ListTile(
                          leading: Icon(Icons.home, size: 30.0,),
                          title: Text('양봉장 장소 관리',
                            style: TextStyle(fontFamily: 'Pretendard', fontSize: 18.0,),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20.0,),
                          onTap: () {
                            print("check");
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ListTile(
                          leading: Icon(Icons.notifications_active_outlined, size: 30.0,),
                          title: Text('알림 관리',
                            style: TextStyle(fontFamily: 'Pretendard', fontSize: 18.0,),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20.0,),
                          onTap: () {
                            print("check");
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ListTile(
                          leading: Icon(Icons.support_agent, size: 30.0,),
                          title: Text('고객 지원',
                            style: TextStyle(fontFamily: 'Pretendard', fontSize: 18.0,),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20.0,),
                          onTap: () {
                            print("check");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
