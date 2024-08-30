import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;

import '../../models/fund/fund_transaction_create.dart';
import '../../models/asset/asset_account.dart';

class FundChargeView extends StatefulWidget {
  final int fundId;
  final String baseURL;

  FundChargeView({required this.fundId, this.baseURL = 'http://10.0.2.2:8080/api'});

  @override
  _FundChargeViewState createState() => _FundChargeViewState();
}

class _FundChargeViewState extends State<FundChargeView> {
  final _formKey = GlobalKey<FormState>();
  final TokenStorage _tokenStorage = TokenStorage();
  int _amount = 0;
  String? _selectedAccount;
  String? _selectedBankName;
  List<AssetAccount> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    final url = Uri.parse('${widget.baseURL}/asset-accounts');
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _accounts = data.map((item) => AssetAccount.fromJson(item)).toList();
          if (_accounts.isNotEmpty) {
            // 초기 선택 계좌 설정
            _selectedAccount = _accounts[0].accountNumber;
            _selectedBankName = _accounts[0].bankName;
          }
          _isLoading = false;
        });
      } else {
        print('Failed to load accounts. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching accounts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createTransaction(FundTransactionCreate transaction) async {
    final url = Uri.parse('${widget.baseURL}/fund/transaction/${widget.fundId}');
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 201) {
        _showCompletionDialog(); // 충전 완료 모달 다이얼로그 띄우기
      } else {
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = decodedResponse['errorMessage'];
        _showErrorDialog(errorMessage);
        print('Failed to create transaction. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating transaction: $e');
      _showErrorDialog('An unexpected error occurred.');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('충전 완료'),
          content: Text('충전이 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(true); // 이전 화면으로 돌아가기
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('충전 실패'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('입금하기'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '충전할 금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '금액 입력',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '금액을 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              Text(
                '계좌 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedAccount,
                items: _accounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account.accountNumber,
                    child: Text('${account.accountNumber} (${account.bankName})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccount = value;
                    _selectedBankName = _accounts
                        .firstWhere((account) => account.accountNumber == value)
                        .bankName;
                  });
                },
              ),
              if (_selectedBankName != null) ...[
                SizedBox(height: 10),
                Text(
                  '은행 이름: $_selectedBankName',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FundTransactionCreate newTransaction = FundTransactionCreate(
                        amount: _amount,
                        type: 'PLUS',
                        accountNo: _selectedAccount!,
                      );

                      // POST 요청 보내기
                      createTransaction(newTransaction);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('충전하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}