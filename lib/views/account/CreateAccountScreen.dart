import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';

class CreateAccountScreen extends StatefulWidget {
  final VoidCallback onAccountCreated;

  CreateAccountScreen({required this.onAccountCreated});

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

        // 은행 코드별로 상품 그룹화
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

  Future<void> _createAccount(BankProduct product) async {
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
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('계좌가 성공적으로 생성되었습니다.')),
          );
          widget.onAccountCreated();
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
          Icon(Icons.account_balance),  // 은행 아이콘
          SizedBox(width: 10),
          Text(products.first.bankName),  // 은행 이름
          Spacer(),
          Text('상품 ${products.length}개'),  // 상품 개수
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
        child: Text('선택'),
        onPressed: () => _createAccount(product),
      ),
    );
  }
}

class BankProduct {
  final String accountTypeUniqueNo;
  final String bankCode;
  final String bankName;
  final String accountTypeCode;
  final String accountTypeName;
  final String accountName;
  final String accountDescription;
  final String accountType;

  BankProduct({
    required this.accountTypeUniqueNo,
    required this.bankCode,
    required this.bankName,
    required this.accountTypeCode,
    required this.accountTypeName,
    required this.accountName,
    required this.accountDescription,
    required this.accountType,
  });

  factory BankProduct.fromJson(Map<String, dynamic> json) {
    return BankProduct(
      accountTypeUniqueNo: json['accountTypeUniqueNo'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      accountTypeCode: json['accountTypeCode'],
      accountTypeName: json['accountTypeName'],
      accountName: json['accountName'],
      accountDescription: json['accountDescription'],
      accountType: json['accountType'],
    );
  }
}