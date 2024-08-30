import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;

import '../../models/fund/fund_overview.dart';
import '../../models/fund/fund_transaction_create.dart'; // FundTransactionCreate 모델 추가
import '../../models/asset/asset_account.dart';

class FundEmergencyWithdrawalView extends StatefulWidget {
  final FundOverview fundOverview;

  FundEmergencyWithdrawalView({required this.fundOverview});

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

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);
  final Color _warningColor = Color(0xFFFF3B30);


  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    final url = Uri.parse('http://3.39.19.140:8080/api/asset-accounts');
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
    final url = Uri.parse('http://3.39.19.140:8080/api/fund/transaction/${widget.fundOverview.fundId}');
    final accessToken = await _tokenStorage.getAccessToken();

    // FundTransactionCreate 객체 생성
    FundTransactionCreate transaction = FundTransactionCreate(
      amount: _withdrawAmount,
      type: 'MINUS',
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
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(true); // 이전 화면으로 돌아가기
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('긴급 출금', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryColor)))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvailableAmountCard(),
                SizedBox(height: 20),
                _buildWithdrawalLimitInfo(remainingWithdrawals),
                SizedBox(height: 20),
                if (remainingWithdrawals > 0) ...[
                  _buildWithdrawAmountInput(),
                  SizedBox(height: 20),
                  _buildAccountSelection(),
                  SizedBox(height: 32),
                  _buildWithdrawButton(remainingWithdrawals),
                ] else
                  _buildWithdrawalNotAvailableMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableAmountCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '출금 가능한 금액',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor),
          ),
          SizedBox(height: 8),
          Text(
            _formatCurrency(widget.fundOverview.currentAmount),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalLimitInfo(int remainingWithdrawals) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: remainingWithdrawals > 0 ? _primaryColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            remainingWithdrawals > 0 ? Icons.info_outline : Icons.warning_amber_rounded,
            color: remainingWithdrawals > 0 ? _primaryColor : _warningColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              remainingWithdrawals > 0
                  ? '긴급 출금 가능 횟수: $remainingWithdrawals'
                  : '긴급 출금 가능 횟수를 모두 사용했습니다.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: remainingWithdrawals > 0 ? _primaryColor : _warningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalNotAvailableMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '출금이 불가능합니다. \n 긴급 출금 횟수를 모두 사용했습니다.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _warningColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWithdrawAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '출금할 금액',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: '금액 입력',
            hintStyle: TextStyle(color: _subTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: _cardColor,
            suffixText: '원',
            suffixStyle: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
          ),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '금액을 입력해주세요';
            }
            int inputAmount = int.parse(value);
            if (inputAmount > widget.fundOverview.currentAmount) {
              return '출금 가능한 금액을 초과했습니다';
            }
            return null;
          },
          onSaved: (value) {
            _withdrawAmount = int.parse(value!);
          },
        ),
      ],
    );
  }

  Widget _buildAccountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '환급받을 계좌',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: _cardColor,
          ),
          value: _selectedAccount,
          items: _accounts.map((account) {
            return DropdownMenuItem<String>(
              value: account.accountNumber,
              child: Text('${account.bankName} ${account.accountNumber}', style: TextStyle(color: _textColor)),
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
      ],
    );
  }

  Widget _buildWithdrawButton(int remainingWithdrawals) {
    return SizedBox(
      width: double.infinity,
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
          backgroundColor: remainingWithdrawals > 0 ? _primaryColor : _subTextColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text('출금하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}