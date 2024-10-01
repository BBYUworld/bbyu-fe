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

  final Map<String, String> _bankImageMap = {
    '한국은행': '금융아이콘_PNG_한국.png',
    '산업은행': '금융아이콘_PNG_산업.png',
    '기업은행': '금융아이콘_PNG_IBK.png',
    '국민은행': '금융아이콘_PNG_KB.png',
    '농협은행': '금융아이콘_PNG_농협.png',
    '우리은행': '금융아이콘_PNG_우리.png',
    'SC제일은행': '금융아이콘_PNG_SC제일.png',
    '시티은행': '금융아이콘_PNG_시티.png',
    '대구은행': '금융아이콘_PNG_대구.png',
    '광주은행': '금융아이콘_PNG_광주.png',
    '제주은행': '금융아이콘_PNG_제주.png',
    '전북은행': '금융아이콘_PNG_전북.png',
    '경남은행': '금융아이콘_PNG_경남.png',
    '새마을금고': '금융아이콘_PNG_MG새마을금고.png',
    'KEB하나은행': '금융아이콘_PNG_하나.png',
    '신한은행': '금융아이콘_PNG_신한.png',
    '카카오뱅크': '금융아이콘_PNG_카카오뱅크.png',
    '싸피은행': '금융아이콘_PNG_싸피.png',
  };

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
      final url = Uri.parse("http://10.0.2.2:8080/user/product");
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
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 계좌 생성', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _groupedBankProducts.length,
        itemBuilder: (context, index) {
          String bankCode = _groupedBankProducts.keys.elementAt(index);
          List<BankProduct> products = _groupedBankProducts[bankCode]!;
          return _buildBankCard(bankCode, products);
        },
      ),
    );
  }

  Widget _buildBankCard(String bankCode, List<BankProduct> products) {
    String bankName = products.first.bankName;
    String imageName = _bankImageMap[bankName] ?? '금융아이콘_PNG_default.png';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Image.asset(
          'assets/images/$imageName',
          width: 40,
          height: 40,
        ),
        title: Text(
          bankName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('상품 ${products.length}개'),
        children: products.map((product) => _buildProductCard(product)).toList(),
      ),
    );
  }

  Widget _buildProductCard(BankProduct product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFE0E0E0), // 연한 회색 배경색
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          product.accountName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(product.accountDescription),
        trailing: ElevatedButton(
          child: Text('계좌 개설'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFFF5E7E0), // 기존의 배경색을 버튼에 그대로 사용
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => _navigateToProductDetail(product),
        ),
      ),
    );
  }
}