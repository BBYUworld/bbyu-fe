import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import '../account/CreateAccountScreen.dart';

class AccountLinkScreen extends StatefulWidget {
  final VoidCallback onComplete;

  AccountLinkScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  _AccountLinkScreenState createState() => _AccountLinkScreenState();


}

class _AccountLinkScreenState extends State<AccountLinkScreen> with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _dataLoaded = false;
  List<Map<String, dynamic>> _accounts = [];
  Set<int> _selectedAccountIndices = {};
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _linkAccount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _linkAccount();
    }
  }
  void reload() {
    _linkAccount();
  }

  Future<void> _linkAccount() async {
    setState(() {
      _isLoading = true;
      _dataLoaded = false;
    });

    try {
      final url = Uri.parse("http://10.0.2.2:8080/user/account");
      final accessToken = await _tokenStorage.getAccessToken();
      final response = await http.get(
          url,
          headers: {
            'Content-Type': "application/json",
            'Authorization': "$accessToken"
          }
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> accountsJson = json.decode(decodedBody);
        setState(() {
          _accounts = List<Map<String, dynamic>>.from(accountsJson);
          _dataLoaded = true;
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
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

  void _showAccountDetails(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 상세 정보'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('은행: ${account['bankName']}'),
                Text('계좌번호: ${account['accountNo']}'),
                Text('계좌명: ${account['accountName']}'),
                Text('계좌 유형: ${account['accountTypeName']}'),
                Text('생성일: ${account['accountCreatedDate']}'),
                Text('만료일: ${account['accountExpiryDate']}'),
                Text('일일 이체 한도: ${account['dailyTransferLimit']}'),
                Text('1회 이체 한도: ${account['oneTimeTransferLimit']}'),
                Text('잔액: ${account['accountBalance']}'),
                Text('통화: ${account['currency']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleAccountSelection(int index) {
    setState(() {
      if (_selectedAccountIndices.contains(index)) {
        _selectedAccountIndices.remove(index);
      } else {
        _selectedAccountIndices.add(index);
      }
    });
  }

  void _confirmAccountLinking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 연결 확인'),
          content: Text('${_selectedAccountIndices.length}개의 계좌를 연결하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onComplete();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('계좌 연결'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateAccount,
        child: Icon(Icons.add),
        tooltip: '새로운 계좌 생성',
      ),
    );
  }

  Widget _buildContent() {
    if (!_dataLoaded) {
      return Center(child: Text('계좌 정보를 확인 중입니다.'));
    } else if (_accounts.isEmpty) {
      return Center(child: Text('연결된 계좌가 없습니다.'));
    } else {
      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _linkAccount,
              child: ListView.builder(
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  final account = _accounts[index];
                  return Card(
                    child: CheckboxListTile(
                      title: Text(account['bankName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(account['accountNo']),
                          Text(account['accountName']),
                        ],
                      ),
                      value: _selectedAccountIndices.contains(index),
                      onChanged: (_) => _toggleAccountSelection(index),
                      secondary: IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () => _showAccountDetails(account),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedAccountIndices.isNotEmpty ? _confirmAccountLinking : null,
              child: Text('${_selectedAccountIndices.length}개의 계좌 연결하기'),
            ),
          ),
        ],
      );
    }
  }
}