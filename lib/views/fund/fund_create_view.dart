import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:http/http.dart' as http;
import '../../models/fund/fund_create.dart';
import '../../models/couple/couple_response.dart';
import 'fund_view.dart';

class FundCreateView extends StatefulWidget {
  @override
  _FundCreateViewState createState() => _FundCreateViewState();
}

class _FundCreateViewState extends State<FundCreateView> {
  final _formKey = GlobalKey<FormState>();
  final TokenStorage _tokenStorage = TokenStorage();
  CoupleResponse? _coupleResponse;
  String _goal = '';
  int _targetAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoupleInfo();
  }

  Future<void> _fetchCoupleInfo() async {
    final url = Uri.parse('http://3.39.19.140:8080/api/couple');
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
          if (_coupleResponse != null) {
            print(_coupleResponse!.coupleId);
          }
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

    final url = Uri.parse('http://3.39.19.140:8080/api/fund/${_coupleResponse!.coupleId}');
    final accessToken = await _tokenStorage.getAccessToken();

    FundCreate newFund = FundCreate(goal: _goal, targetAmount: _targetAmount);

    try {
      print("@@@@@@@@@@@@@@@@@@@@@@");
      print(newFund.targetAmount);
      print(newFund.goal);
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '목표 금액 입력(원)',
                  suffixText: '원', // '원' 단위 추가
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '목표 금액을 입력해주세요';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return '유효한 금액을 입력해주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _targetAmount = int.parse(value!);
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