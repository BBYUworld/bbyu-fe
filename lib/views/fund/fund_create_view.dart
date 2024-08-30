import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../models/fund/fund_create.dart';
import '../../models/couple/couple_response.dart';
import 'fund_view.dart';

class FundCreateView extends StatefulWidget {
  @override
  _FundCreateViewState createState() => _FundCreateViewState();
}

class _FundCreateViewState extends State<FundCreateView> {
  final _formKey = GlobalKey<FormState>(); // form key
  final TokenStorage _tokenStorage = TokenStorage(); // token storage
  CoupleResponse? _coupleResponse;
  String _goal = '';
  int _targetAmount = 0;
  bool _isLoading = true;

  // TextEditingController 및 NumberFormat 초기화
  final TextEditingController _targetAmountController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    _fetchCoupleInfo();

    // 목표 금액 입력 필드에 대한 리스너 추가
    _targetAmountController.addListener(_formatTargetAmount);
  }

  @override
  void dispose() {
    // 컨트롤러 정리
    _targetAmountController.dispose();
    super.dispose();
  }

  // 입력값을 포맷팅하는 함수
  void _formatTargetAmount() {
    String text = _targetAmountController.text.replaceAll(',', '');
    if (text.isEmpty) return;

    // 숫자만 추출
    int? value = int.tryParse(text);
    if (value == null) return;

    String formatted = _numberFormat.format(value);
    if (formatted != _targetAmountController.text) {
      _targetAmountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _fetchCoupleInfo() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/couple');
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
        setState(() {
          _coupleResponse = CoupleResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
          _isLoading = false;
        });
      } else {
        print('Failed to load couple information. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching couple information: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createFund() async {
    if (_coupleResponse == null) return;

    print('${_coupleResponse!.coupleId}');

    final url = Uri.parse('http://10.0.2.2:8080/api/fund/${_coupleResponse!.coupleId}');
    final accessToken = await _tokenStorage.getAccessToken();

    FundCreate newFund = FundCreate(goal: _goal, targetAmount: _targetAmount);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(newFund.toJson()),
      );

      if (response.statusCode == 201) {
        _showCompletionDialog();
      } else {
        print('Failed to create fund. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating fund: $e');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('펀드 생성 완료'),
          content: Text('펀드가 성공적으로 생성되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => FundView()), // Navigate to FundView
                );
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
        title: Text('펀드 생성'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '펀드 목표',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '펀드 목표 입력',
                  hintText: 'ex) 한강뷰 아파트', // 예시 텍스트 추가
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '펀드 목표를 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goal = value!;
                },
              ),
              SizedBox(height: 20),
              Text(
                '목표 금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _targetAmountController, // 컨트롤러 할당
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '목표 금액 입력',
                  hintText: 'ex) 1,000,000,000', // 예시 텍스트 추가
                  suffixText: '원', // '원' 단위 추가
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '목표 금액을 입력해주세요';
                  }
                  // 콤마 제거 후 숫자 확인
                  String numericString = value.replaceAll(',', '');
                  if (int.tryParse(numericString) == null || int.parse(numericString) <= 0) {
                    return '유효한 금액을 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  // 콤마 제거 후 정수로 변환
                  String numericString = value!.replaceAll(',', '');
                  _targetAmount = int.parse(numericString);
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _createFund();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('펀드 생성하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}