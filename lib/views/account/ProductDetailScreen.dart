// file: lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/BankProduct.dart';  // BankProduct 모델을 별도 파일로 분리했다고 가정

class ProductDetailScreen extends StatelessWidget {
  final BankProduct product;
  final VoidCallback onCreateAccount;
  final TokenStorage _tokenStorage = TokenStorage();

  ProductDetailScreen({required this.product, required this.onCreateAccount});

  Future<void> _createAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 생성 확인'),
          content: Text('${product.accountName} 상품으로 계좌를 생성하시겠습니까?'),
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
        final url = Uri.parse("http://10.0.2.2:8080/user/account");
        final accessToken = await _tokenStorage.getAccessToken();
        final response = await http.post(
          url,
          headers: {
            'Content-Type': "application/json",
            'Authorization': "$accessToken"
          },
          body: json.encode({
            'accountTypeUniqueNo': product.accountTypeUniqueNo,
            'bankName' : product.bankName,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('계좌가 성공적으로 생성되었습니다.')),
          );
          onCreateAccount();
          Navigator.of(context).pop(); // 상세 화면 닫기
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('은행: ${product.bankName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('상품명: ${product.accountName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('상품 설명: ${product.accountDescription}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('계좌 유형: ${product.accountTypeName}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('계좌 종류: ${product.accountType}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                child: Text('이 상품으로 계좌 만들기'),
                onPressed: () => _createAccount(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}