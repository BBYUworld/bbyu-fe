import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/BankProduct.dart';
import 'package:gagyebbyu_fe/views/login/AccountLinkScreen.dart';


class ProductDetailScreen extends StatefulWidget {
  final BankProduct product;
  final VoidCallback onCreateAccount;
  final Map<String, dynamic> additionalInfo;

  ProductDetailScreen({required this.product, required this.onCreateAccount, required this.additionalInfo});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TokenStorage _tokenStorage = TokenStorage();
  final _formKey = GlobalKey<FormState>();
  final _dailyTransferLimitController = TextEditingController();
  final _oneTimeTransferLimitController = TextEditingController();

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 생성 확인'),
          content: Text('${widget.product.accountName} 상품으로 계좌를 생성하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final url = Uri.parse("http://3.39.19.140:8080/user/account");
        final accessToken = await _tokenStorage.getAccessToken();
        final response = await http.post(
          url,
          headers: {
            'Content-Type': "application/json",
            'Authorization': "$accessToken"
          },
          body: json.encode({
            'accountTypeUniqueNo': widget.product.accountTypeUniqueNo,
            'bankName': widget.product.bankName,
            'dailyTransferLimit': int.parse(_dailyTransferLimitController.text),
            'oneTimeTransferLimit': int.parse(_oneTimeTransferLimitController.text),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('계좌가 성공적으로 생성되었습니다.')),
          );
          widget.onCreateAccount();
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('계좌 생성에 실패했습니다. 다시 시도해주세요.')),
          );
        }
      } catch (e) {
        print('Exception occurred while creating account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 상세 정보'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('은행: ${widget.product.bankName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('상품명: ${widget.product.accountName}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('상품 설명: ${widget.product.accountDescription}', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('계좌 유형: ${widget.product.accountTypeName}', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('계좌 종류: ${widget.product.accountType}', style: TextStyle(fontSize: 14)),
              SizedBox(height: 24),
              TextFormField(
                controller: _dailyTransferLimitController,
                decoration: InputDecoration(
                  labelText: '일일 최대 이체 금액',
                  hintText: '숫자만 입력해주세요',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '일일 최대 이체 금액을 입력해주세요.';
                  }
                  if (int.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _oneTimeTransferLimitController,
                decoration: InputDecoration(
                  labelText: '1회 최대 이체 금액',
                  hintText: '숫자만 입력해주세요',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '1회 최대 이체 금액을 입력해주세요.';
                  }
                  if (int.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  child: Text('이 상품으로 계좌 만들기'),
                  onPressed: _createAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dailyTransferLimitController.dispose();
    _oneTimeTransferLimitController.dispose();
    super.dispose();
  }
}