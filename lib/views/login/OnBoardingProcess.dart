import 'package:flutter/material.dart';
import './AdditionalInfoScreen.dart';
import 'package:http/http.dart' as http;
import './AccountLinkScreen.dart';
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/views/home/MainPage.dart';
import 'package:gagyebbyu_fe/views/account/CreateAccountScreen.dart';

class OnboardingProcess extends StatefulWidget {
  final String email;
  OnboardingProcess({required this.email});

  @override
  _OnboardingProcessState createState() => _OnboardingProcessState();
}

class _OnboardingProcessState extends State<OnboardingProcess> {
  int _currentStep = 0;
  Map<String, dynamic> _additionalInfo = {};
  List<Map<String, dynamic>> _selectedAccounts = [];
  bool _isAccountLinked = false;
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '첫 로그인을 환영합니다!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // 신한은행 파란색
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '원활한 서비스 제공을 위해\n추가 정보를 입력해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextButton(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // 신한은행 파란색
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCreateAccount() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateAccountScreen(
          onAccountCreated: () {
            // 이 콜백은 더 이상 필요하지 않을 수 있습니다.
          },
          additionalInfo: _additionalInfo,
        ),
      ),
    );

    if (result == true) {
      // 계좌가 성공적으로 생성됨
      setState(() {
        _currentStep = 1;  // AccountLinkScreen을 다시 로드
      });
    }
  }
  Future<void> _saveAccountToServer() async{
    print("additional Info = $_additionalInfo");
    print("selectedAccounts = $_selectedAccounts");
    final url = Uri.parse("http://10.0.2.2:8080/user/adittional/info");
    final accessToken = await _tokenStorage.getAccessToken();
    final jsonData = {
      "additionalInfo": {
        "gender": _additionalInfo['gender'],
        "age": _additionalInfo['age'],
        "salary": _additionalInfo['salary'],
        "desiredSpending": _additionalInfo['desiredSpending'],
        "region": _additionalInfo['region'],
        "occupation" : _additionalInfo['occupation']
      },
      "selectedAccounts": _selectedAccounts,
    };
    print('Sending JSON: ${json.encode(jsonData)}');
    final response = await http.post(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization': "$accessToken"
        },
      body: json.encode({
        "additionalInfo": {
          "gender": _additionalInfo['gender'],
          "age": _additionalInfo['age'],
          "salary": _additionalInfo['salary'],
          "desiredSpending": _additionalInfo['desiredSpending'],
          "region": _additionalInfo['region'],
          "occupation" : _additionalInfo['occupation']
        },
        "selectedAccounts": _selectedAccounts,
      }),
    );

    if(response.statusCode == 200){
      _completeOnboarding();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
    else{
      print('Failed to save account info: ${response.statusCode}');
    }

  }

  void _onAdditionalInfoComplete(Map<String, dynamic> info) {
    setState(() {
      _additionalInfo = info;
      _currentStep = 1;
    });
  }

  void _onAccountLinked(List<Map<String, dynamic>> selectedAccounts) {
    setState(() {
      _selectedAccounts = selectedAccounts;
      print('Selected Accounts = $_selectedAccounts');
      _isAccountLinked = true;
    });
    _saveAccountToServer();
  }

  void _completeOnboarding() {
    if (_additionalInfo.isNotEmpty && _isAccountLinked) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('온보딩 완료'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이메일: ${widget.email}'),
                Text('추가 정보 입력과 계좌 연결이 완료되었습니다.'),
                SizedBox(height: 10),
                Text('선택된 계좌:'),
                ..._selectedAccounts.map((account) => Text('- ${account['bankName']}: ${account['accountNo']}')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to the main app screen
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: _currentStep == 0 ? null : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _currentStep = 0;
            });
          },
        ),
      ),
      body: _currentStep == 0
          ? AdditionalInfoScreen(onComplete: _onAdditionalInfoComplete)
          : AccountLinkScreen(
        key: UniqueKey(),
        onComplete: _onAccountLinked,
        additionalInfo: _additionalInfo,
        onCreateAccount: _navigateToCreateAccount,
      ),
    );
  }
}