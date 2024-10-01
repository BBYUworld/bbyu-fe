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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController1 = TextEditingController();
  final TextEditingController _phoneController2 = TextEditingController();
  final TextEditingController _phoneController3 = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();
  bool existCheck = false;

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
      _showSnackBar("이메일을 먼저 입력해주세요.");
      return;
    }
    try {
      final email = Uri.encodeQueryComponent(_emailController.text);
      final url = Uri.parse("http://10.0.2.2:8080/user/search?email=$email");
      final response = await http.get(
        url,
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody == "not Exist") {
          existCheck = true;
          _showSnackBar("사용 가능한 이메일입니다.");
        } else if (responseBody == "is Exist") {
          _showSnackBar("이미 사용중인 이메일입니다.");
        } else {
          _showSnackBar("예상치 못한 응답이 발생했습니다.");
        }
      } else {
        _showSnackBar("서버 오류가 발생했습니다.");
      }
    } catch(e) {
      _showSnackBar("오류가 발생했습니다.");
    }
  }

  Future<void> _register() async {
    if(!existCheck){
      _showSnackBar("이메일 중복조회를 먼저 진행해주세요.");
      return;
    }
    final url = Uri.parse('http://10.0.2.2:8080/user/regist');
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
        _showSnackBar("이미 존재하는 사용자입니다.");
      }
    }
    catch (e) {
      _showSnackBar('오류가 발생했습니다. 다시 시도해주세요.');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFFFF6B6B);
    final Color backgroundColor = Color(0xFFF9FAFB);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField('이메일', _emailController,
                suffix: ElevatedButton(
                  onPressed: _validateUserAlreadyExist,
                  child: Text('중복확인'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: primaryColor,
                  ),
                )
            ),
            SizedBox(height: 16),
            _buildInputField('비밀번호', _passwordController, isPassword: true),
            SizedBox(height: 16),
            _buildInputField('이름', _nameController),
            SizedBox(height: 16),
            _buildPhoneNumberField(),
            SizedBox(height: 16),
            _buildInputField('우편번호', _postcodeController,
                readOnly: true,
                suffix: ElevatedButton(
                  onPressed: () => _searchAddress(context),
                  child: Text('주소 검색'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: primaryColor,
                  ),
                )
            ),
            SizedBox(height: 16),
            _buildInputField('기본주소', _addressController, readOnly: true),
            SizedBox(height: 16),
            _buildInputField('상세주소', _addressDetailController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _register,
              child: Text('회원가입 완료', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isPassword = false, bool readOnly = false, Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
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
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('전화번호', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildPhoneInput(_phoneController1, 3),
            ),
            Text(' - ', style: TextStyle(fontSize: 20)),
            Expanded(
              flex: 4,
              child: _buildPhoneInput(_phoneController2, 4),
            ),
            Text(' - ', style: TextStyle(fontSize: 20)),
            Expanded(
              flex: 4,
              child: _buildPhoneInput(_phoneController3, 4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneInput(TextEditingController controller, int maxLength) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
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
    );
  }
}