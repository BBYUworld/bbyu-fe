import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> _login() async {
    print("로그인 함수 호출");
    final url = Uri.parse('http://10.0.2.2:8080/user/login');
    print("아이디 = "+_idController.text);
    print("비밀번호 = "+_passwordController.text);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _idController.text,
          'password': _passwordController.text,
        }),
      );
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody);

      print('json Response : $jsonResponse');
      print('json Response Token : ${jsonResponse['token']}');
      print('json Response AccessToken : ${jsonResponse['token']?['accessToken']}');
      print('json Response RefreshToken : ${jsonResponse['token']?['refreshToken']}');
      print('json Response isLogin : ${jsonResponse['_first_login']}');

      await _tokenStorage.saveTokens(
          jsonResponse['token']['accessToken'],
          jsonResponse['token']['refreshToken']
      );
      final accessToken = _tokenStorage.getAccessToken();
      final refreshToken = _tokenStorage.getRefreshToken();
      print('accessToken = $accessToken');
      print('refreshToken = $refreshToken');
      if (response.statusCode == 200) {
        _showLoginSuccessDialog();
        print('Login successful');
        print('Response body: ${response.body}');
      } else {
        _showErrorDialog('로그인 실패. 다시 시도해주세요.');
        print('Login failed');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorDialog('오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 성공'),
          content: Text('환영합니다! 로그인에 성공하였습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // TODO: 여기에 로그인 성공 후 처리 (예: 홈 화면으로 이동) 추가
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // build 메서드는 변경 없음
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}