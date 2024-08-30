import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OnBoardingProcess.dart';
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

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TokenStorage _tokenStorage = TokenStorage();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://3.39.19.140:8080/user/login');
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

      if (response.statusCode == 200) {
        await _tokenStorage.saveTokens(
            jsonResponse['token']['accessToken'],
            jsonResponse['token']['refreshToken']
        );

        if (jsonResponse['_first_login'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardingProcess(email: _idController.text),
            ),
          );
        } else {
          _showLoginSuccessDialog();
        }
      } else {
        _showErrorDialog('로그인 실패. 아이디와 비밀번호를 확인해주세요.');
      }
    } catch (e) {
      _showErrorDialog('오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFFFF6B6B);
    final Color backgroundColor = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                '안녕하세요\n가계쀼에 오신 것을\n환영합니다',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 40),
              _buildAnimatedInputField('아이디', _idController),
              SizedBox(height: 16),
              _buildAnimatedInputField('비밀번호', _passwordController, isPassword: true),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('로그인', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 55),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text(
                    '새로운 계정 만들기',
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: controller,
                  obscureText: isPassword,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}