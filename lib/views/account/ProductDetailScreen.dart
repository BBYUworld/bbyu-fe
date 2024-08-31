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

  final Color _primaryColor = Color(0xFFFFF2F2);
  final Color _textColor = Color(0xFF4A4A4A);

  // 은행 이름과 이미지 파일 이름 매핑
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

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 생성 확인', style: TextStyle(color: _textColor)),
          content: Text('${widget.product.accountName} 상품으로 계좌를 생성하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: _textColor)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('확인', style: TextStyle(color: _textColor)),
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
        title: Text('상품 상세 정보', style: TextStyle(color: _textColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              SizedBox(height: 24),
              _buildLimitInputs(),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  child: Text('이 상품으로 계좌 만들기', style: TextStyle(color: _textColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _createAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    String imageName = _bankImageMap[widget.product.bankName] ?? '금융아이콘_PNG_default.png';

    return Card(
      color: _primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/$imageName',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 12),
                Text(
                  widget.product.bankName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(widget.product.accountName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
            SizedBox(height: 8),
            Text(widget.product.accountDescription, style: TextStyle(fontSize: 14, color: _textColor)),
            SizedBox(height: 8),
            Text('계좌 유형: ${widget.product.accountTypeName}', style: TextStyle(fontSize: 14, color: _textColor)),
            SizedBox(height: 4),
            Text('계좌 종류: ${widget.product.accountType}', style: TextStyle(fontSize: 14, color: _textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitInputs() {
    return Column(
      children: [
        TextFormField(
          controller: _dailyTransferLimitController,
          decoration: InputDecoration(
            labelText: '일일 최대 이체 금액',
            hintText: '숫자만 입력해주세요',
            border: OutlineInputBorder(),
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
            border: OutlineInputBorder(),
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
      ],
    );
  }

  @override
  void dispose() {
    _dailyTransferLimitController.dispose();
    _oneTimeTransferLimitController.dispose();
    super.dispose();
  }
}