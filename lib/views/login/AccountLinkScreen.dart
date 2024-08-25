import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import '../account/CreateAccountScreen.dart';
class AccountLinkScreen extends StatefulWidget {
  final VoidCallback onComplete;

  AccountLinkScreen({required this.onComplete});

  @override
  _AccountLinkScreenState createState() => _AccountLinkScreenState();
}

class _AccountLinkScreenState extends State<AccountLinkScreen> {
  bool _isLoading = false;
  bool _dataLoaded = false;
  bool _hasAccount = false;
  final TokenStorage _tokenStorage = TokenStorage();
  Future<void> _linkAccount() async {

    try {
      final url = Uri.parse("http://10.0.2.2:8080/user/account");
      final accessToken = await _tokenStorage.getAccessToken();
      print("accessToken = $accessToken");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': "application/json",
          'Authorization' : "$accessToken"
        }
      );
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');

      final decodedBody = utf8.decode(response.bodyBytes);
      print('Raw Response Body: $decodedBody');
      if (response.statusCode == 200) {
        setState(() {
          _dataLoaded = true;
        });
        if (decodedBody.isEmpty || decodedBody == "[]") {
          setState(() {
            _hasAccount = false;
          });
        } else {
          setState(() {
            _hasAccount = true;
          });
          // 기존 계좌 정보 처리 로직
        }
      }
      else if(response.statusCode == 401){

      }
      else {

      }
    } catch (e) {

    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToCreateAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateAccountScreen(
          onAccountCreated: () {
            _linkAccount();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_dataLoaded
              ? (_hasAccount ? '연결된 계좌가 있습니다.' : '연결된 계좌가 없습니다.')
              : '계좌 정보를 확인 중입니다.'),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (!_dataLoaded) {
      return ElevatedButton(
        onPressed: _linkAccount,
        child: Text('계좌 연결'),
      );
    } else if (_hasAccount) {
      return ElevatedButton(
        onPressed: widget.onComplete,
        child: Text('계속하기'),
      );
    } else {
      return ElevatedButton(
        onPressed: _navigateToCreateAccount,
        child: Text('새로운 계좌 생성'),
      );
    }
  }
}