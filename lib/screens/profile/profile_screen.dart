import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../theme/colors.dart';

void getNameRequest(BuildContext context, void Function(String) onNameLoaded) async {
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
      // UTF-8로 응답 바이트를 디코딩합니다.
      final responseBody = utf8.decode(response.bodyBytes);
      // 디코딩된 응답을 JSON으로 파싱합니다.
      final decodedJson = jsonDecode(responseBody);
      final name = decodedJson['name'];
      print(decodedJson);

      if (name == null || name.isEmpty) {
        onNameLoaded('이름을 입력해주세요');
      } else {
        onNameLoaded(name);
      }
    } else if (response.statusCode == 400) {
      print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
      await Provider.of<AuthProvider>(context, listen: false).logout();
      context.go('/login'); // 로그인 페이지로 리디렉션
      throw Exception('Failed to load name. Status code: 400');
    }
  } catch (e) {
    print('Error: $e');
    onNameLoaded('이름을 가져오지 못했습니다.');
  }
}

void editNameRequest(BuildContext context, String name, void Function(String) onNameEdited) async {
  final url = Uri.parse('http://kulbul.iptime.org:8000/user/edit');

  final response = await http.patch(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',
    },
    body: jsonEncode({
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    onNameEdited(name);
  } else if (response.statusCode == 400) {
    print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
    await Provider.of<AuthProvider>(context, listen: false).logout();
    context.go('/login'); // 로그인 페이지로 리디렉션
    throw Exception('Failed to edit name. Status code: 400');
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String _name = '';
  bool _isLoading = true; // 로딩 상태를 관리

  @override
  void initState() {
    super.initState();
    _loadName(); // 화면이 처음 로드될 때 이름을 불러옵니다.
  }

  void _loadName() {
    getNameRequest(context, (name) {
      setState(() {
        _name = name;
        _isLoading = false; // 이름 로딩 완료 후 로딩 상태 false로 변경
      });
    });
  }

  Future<void> _showNameDialog() async {
    String tempName = _name;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이름 설정'),
          content: TextField(
            onChanged: (value) {
              tempName = value;
            },
            decoration: InputDecoration(
              hintText: "이름을 입력해주세요.",
              border: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: yelloMyStyle1), // 포커스 시 색상 변경
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: blackMyStyle2),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: blackMyStyle2,),),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: Text('저장', style: TextStyle(color: blackMyStyle2,),),
              onPressed: () {
                editNameRequest(context, tempName, (newName) {
                  setState(() {
                    _name = newName;
                  });
                }); // 이름 수정 요청
                context.pop();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                backgroundColor: yelloMyStyle1,
                foregroundColor: blackMyStyle1,
                padding: EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: ClearMyStyle1,
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  context.go('/intro');
                },
                icon: Icon(
                    Icons.logout,
                    color: blackMyStyle2,
                    size: 24
                )
            ),
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

        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // 로딩 중일 때는 로딩 스피너를 표시
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                child: Center(
                  child: ListTile(
                    leading: Icon(Icons.face, size: 50.0,),
                    title: Text(
                      _name,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'PretendardBold'
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20.0,),
                    onTap: () {
                      _showNameDialog();
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0,),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
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
                            context.push('/location');
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
