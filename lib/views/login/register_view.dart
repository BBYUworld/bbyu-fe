import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_view.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController1 = TextEditingController();
  final TextEditingController _phoneController2 = TextEditingController();
  final TextEditingController _phoneController3 = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();
  String _gender = "";
  String authNumber = "";
  bool existCheck = false;
  bool genderCheck = false;

  String get formattedPhoneNumber {
    return "${_phoneController1.text}-${_phoneController2.text}-${_phoneController3.text}";
  }

  bool get isPhoneNumberValid {
    return _phoneController1.text.length == 3 &&
        _phoneController2.text.length == 4 &&
        _phoneController3.text.length == 4;
  }

  void _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null) {
      setState(() {
        _postcodeController.text = model.zonecode ?? '';
        _addressController.text = model.address ?? '';
        _addressDetailController.text = model.buildingName ?? '';
      });
    }
  }

  Future<void> _validateUserAlreadyExist() async {
    if (_emailController.text.isEmpty) {
      _showDialog("이메일을 먼저 입력해주세요.");
      return;
    }
    try{
      final email = Uri.encodeQueryComponent(_emailController.text);
      final url = Uri.parse("http://3.39.19.140:8080/user/search?email=$email");
      final response = await http.get(
        url,
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == "not Exist") {
          existCheck = true;
          print("사용자가 존재하지 않습니다.");
          _showDialog("사용 가능한 이메일입니다.");
        } else if (responseBody == "is Exist") {
          _showDialog("이미 사용중인 이메일입니다.");
          print("사용자가 이미 존재합니다.");
        } else {
          print("예상치 못한 응답: $responseBody");
        }
      } else {
        print("서버 오류: ${response.statusCode}");
      }
    } catch(e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _register() async {
    if(!existCheck){
      _showDialog("이메일 중복조회를 먼저 진행해주세요.");
      return;
    }
    print("주소 테스트 : ${_postcodeController.text} ${_addressController.text} ${_addressDetailController.text}");
    final url = Uri.parse('http://3.39.19.140:8080/user/regist');
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'name' : _nameController.text,
          'phone' : formattedPhoneNumber,
          'address' : "${_addressController.text} ${_addressDetailController.text}",
        }),
      );
      if (response.statusCode == 200) {
        _showRegistSuccessDialog();
      } else if(response.statusCode == 400) {
        print("이미 존재하는 사용자");
      }
    }
    catch (e) {
      print('Error occurred: $e');
      _showErrorDialog('오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void _showRegistSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 성공'),
          content: Text('환영합니다! 회원가입에 성공하였습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLogin();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('안내문'),
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

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFF5E7E0)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo1-removebg-preview.png',
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24),

            _buildSectionTitle('기본 정보'),
            SizedBox(height: 16),
            _buildEmailField(),
            SizedBox(height: 16),
            _buildInputField('비밀번호', _passwordController, isPassword: true),
            SizedBox(height: 16),
            _buildInputField('이름', _nameController),

            SizedBox(height: 24),

            _buildSectionTitle('연락처 정보'),
            SizedBox(height: 16),
            _buildPhoneNumberField(),

            SizedBox(height: 24),

            _buildSectionTitle('주소 정보'),
            SizedBox(height: 16),
            _buildPostcodeField(),
            SizedBox(height: 16),
            _buildInputField('기본주소', _addressController, readOnly: true),
            SizedBox(height: 16),
            _buildInputField('상세주소', _addressDetailController),

            SizedBox(height: 32),

            ElevatedButton(
              onPressed: _register,
              child: Text('회원가입'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5E7E0),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color(0xFFF5E7E0).withOpacity(0.3),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이메일', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 7,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: _validateUserAlreadyExist,
                child: Text('중복확인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5E7E0),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostcodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('우편번호', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 7,
              child: TextField(
                controller: _postcodeController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () => _searchAddress(context),
                child: Text('주소 검색'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5E7E0),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('전화번호', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _phoneController1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Text(' - '),
            Expanded(
              child: TextField(
                controller: _phoneController2,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Text(' - '),
            Expanded(
              child: TextField(
                controller: _phoneController3,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}