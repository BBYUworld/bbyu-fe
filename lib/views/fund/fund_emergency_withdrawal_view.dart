import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;

import '../../models/fund/fund_overview.dart';
import '../../models/fund/fund_transaction_create.dart';
import '../../models/asset/asset_account.dart';

class FundEmergencyWithdrawalView extends StatefulWidget {
  final FundOverview fundOverview;
  final String baseURL;

  FundEmergencyWithdrawalView({required this.fundOverview, this.baseURL = 'http://10.0.2.2:8080/api'});

  @override
  _FundEmergencyWithdrawalViewState createState() => _FundEmergencyWithdrawalViewState();
}

class _FundEmergencyWithdrawalViewState extends State<FundEmergencyWithdrawalView> {
  final _formKey = GlobalKey<FormState>();
  final TokenStorage _tokenStorage = TokenStorage();
  String? _selectedAccount;
  String? _selectedBankName;
  List<AssetAccount> _accounts = [];
  bool _isLoading = true;
  int _withdrawAmount = 0;

  final TextEditingController _amountController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
    _amountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    String text = _amountController.text.replaceAll(',', '');
    if (text.isEmpty) return;

    int? value = int.tryParse(text);
    if (value == null) return;

    String formatted = _numberFormat.format(value);
    if (formatted != _amountController.text) {
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
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

  Future<void> createEmergencyWithdrawalTransaction() async {
    final url = Uri.parse('${widget.baseURL}/fund/transaction/${widget.fundOverview.fundId}');
    final accessToken = await _tokenStorage.getAccessToken();

    FundTransactionCreate transaction = FundTransactionCreate(
      amount: _withdrawAmount,
      type: 'MINUS',
      accountNo: _selectedAccount!,
    );

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
        _showCompletionDialog();
      } else {
        print('Failed to create transaction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating transaction: $e');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('출금 완료'),
          content: Text('긴급 출금이 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int remainingWithdrawals = 2 - widget.fundOverview.emergencyCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('긴급 출금'),
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
                '출금 가능한 금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${_formatCurrency(widget.fundOverview.currentAmount)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              SizedBox(height: 20),
              Text(
                '긴급 출금 가능 횟수: $remainingWithdrawals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '출금할 금액 입력',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '금액 입력(원)',
                  suffixText: '원',  // '원' 단위 추가
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '금액을 입력해주세요';
                  }
                  String numericString = value.replaceAll(',', '');
                  int inputAmount = int.parse(numericString);
                  if (inputAmount > widget.fundOverview.currentAmount) {
                    return '출금 가능한 금액을 초과했습니다';
                  }
                  return null;
                },
                onSaved: (value) {
                  String numericString = value!.replaceAll(',', '');
                  _withdrawAmount = int.parse(numericString);
                },
              ),
              SizedBox(height: 20),
              Text(
                '환급받을 계좌 선택',
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
                  onPressed: remainingWithdrawals > 0
                      ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      createEmergencyWithdrawalTransaction();
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: remainingWithdrawals > 0 ? Colors.pinkAccent : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('출금하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}
