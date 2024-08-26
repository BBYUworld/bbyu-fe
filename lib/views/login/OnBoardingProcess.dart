import 'package:flutter/material.dart';
import './AdditionalInfoScreen.dart';
import 'package:http/http.dart' as http;
import './AccountLinkScreen.dart';
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';


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
        "desiredSpending": _additionalInfo['desiredSpending']
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
          "desiredSpending": _additionalInfo['desiredSpending']
        },
        "selectedAccounts": _selectedAccounts,
      }),
    );

    if(response.statusCode == 200){

    }
    else{

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
    _completeOnboarding();
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
        title: Text('${widget.email} 추가 정보 입력'),
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
        key: ValueKey(_currentStep),
        onComplete: _onAccountLinked,
        additionalInfo: _additionalInfo,
      ),
    );
  }
}