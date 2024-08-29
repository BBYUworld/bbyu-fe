import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_view.dart';
import '../test/KakaoAddressScreen.dart';
import '../fund/fund_view.dart';
import '../login/AdditionalInfoScreen.dart';
import './OnBoardingProcess.dart';
import 'package:gagyebbyu_fe/views/home/MainPage.dart';

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
    final url = Uri.parse('http://3.39.19.140:8080/user/login');
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
        if (jsonResponse['_first_login'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardingProcess(email: _idController.text),
            ),
          );
        } else {
          _showLoginSuccessDialog();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        }
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
    final Color mainColor = Color(0xFFF5E7E0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/images/logo1-removebg-preview.png',
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            _buildInputField('아이디', _idController),
            SizedBox(height: 16),
            _buildInputField('비밀번호', _passwordController, isPassword: true),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text('로그인', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterView()),
                      );
                    },
                    child: Text('회원가입', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: mainColor),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5E7E0)),
            ),
          ),
        ),
      ],
    );
  }
}