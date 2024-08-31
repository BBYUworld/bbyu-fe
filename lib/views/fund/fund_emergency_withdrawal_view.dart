import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;

import '../../models/fund/fund_overview.dart';
import '../../models/fund/fund_transaction_create.dart';
import '../../models/asset/asset_account.dart';

class FundEmergencyWithdrawalView extends StatefulWidget {
  final FundOverview fundOverview;
  final String baseURL;

  FundEmergencyWithdrawalView({required this.fundOverview, this.baseURL = 'http://3.39.19.140:8080/api'});

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
          title: Text('출금 완료', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('긴급 출금이 완료되었습니다.', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('닫기', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
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
                _buildWithdrawAmountInput(),
                SizedBox(height: 20),
                _buildAccountSelection(),
                SizedBox(height: 32),
                _buildWithdrawButton(remainingWithdrawals),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableAmountCard() {
    return Container(
      width: double.infinity, // 이 줄을 추가하여 너비를 전체로 확장
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
                  : '긴급 출금 횟수를 모두 사용했습니다.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: remainingWithdrawals > 0 ? Color(0xFF3182F6) : _warningColor,
              ),
            ),
          ),
        ],
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
          controller: _amountController,
          decoration: InputDecoration(
            hintText: '0',
            suffixText: '원',
            suffixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _subTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: _cardColor,
          ),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        child: Text('긴급 출금하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}