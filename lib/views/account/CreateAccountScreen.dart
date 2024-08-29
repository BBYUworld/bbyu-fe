// file: lib/screens/create_account_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/BankProduct.dart';
import 'package:gagyebbyu_fe/views/account/ProductDetailScreen.dart';

class CreateAccountScreen extends StatefulWidget {
  final VoidCallback onAccountCreated;
  final Map<String, dynamic> additionalInfo;


  CreateAccountScreen({required this.onAccountCreated, required this.additionalInfo});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isLoading = false;
  Map<String, List<BankProduct>> _groupedBankProducts = {};
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    _fetchBankProducts();
  }

  Future<void> _fetchBankProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse("http://3.39.19.140:8080/user/product");
      final accessToken = await _tokenStorage.getAccessToken();
      final response = await http.get(
          url,
          headers: {
            'Content-Type': "application/json",
            'Authorization': "$accessToken"
          }
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      print('status code = ${response.statusCode}');
      print('Raw Response Body: $decodedBody');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(decodedBody);
        final products = productsJson.map((json) => BankProduct.fromJson(json)).toList();

        _groupedBankProducts = {};
        for (var product in products) {
          if (!_groupedBankProducts.containsKey(product.bankCode)) {
            _groupedBankProducts[product.bankCode] = [];
          }
          _groupedBankProducts[product.bankCode]!.add(product);
        }

        setState(() {});
      } else {
        print('Error fetching bank products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProductDetail(BankProduct product) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          onCreateAccount: widget.onAccountCreated,
          additionalInfo: widget.additionalInfo,
        ),
      ),
    );

    if (result == true) {
      // 계좌가 성공적으로 생성됨
      Navigator.of(context).pop(true);  // CreateAccountScreen을 종료하고 true를 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 계좌 생성'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _groupedBankProducts.length,
        itemBuilder: (context, index) {
          String bankCode = _groupedBankProducts.keys.elementAt(index);
          List<BankProduct> products = _groupedBankProducts[bankCode]!;
          return _buildBankExpansionTile(bankCode, products);
        },
      ),
    );
  }

  Widget _buildBankExpansionTile(String bankCode, List<BankProduct> products) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(Icons.account_balance),
          SizedBox(width: 10),
          Text(products.first.bankName),
          Spacer(),
          Text('상품 ${products.length}개'),
        ],
      ),
      children: products.map((product) => _buildProductListTile(product)).toList(),
    );
  }

  Widget _buildProductListTile(BankProduct product) {
    return ListTile(
      title: Text(product.accountName),
      subtitle: Text(product.accountDescription),
      trailing: ElevatedButton(
        child: Text('상세 정보'),
        onPressed: () => _navigateToProductDetail(product),
      ),
    );
  }
}