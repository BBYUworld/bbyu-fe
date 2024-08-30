import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final Color _primaryColor = Color(0xFF3182F6);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

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
          title: Text('펀드 생성 완료', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('펀드가 성공적으로 생성되었습니다.', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => FundView()),
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('펀드 생성', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
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
                _buildInputField('펀드 목표', (value) {
                  if (value == null || value.isEmpty) {
                    return '펀드 목표를 입력해주세요';
                  }
                  return null;
                }, (value) {
                  _goal = value!;
                }),
                SizedBox(height: 24),
                _buildInputField('목표 금액', (value) {
                  if (value == null || value.isEmpty) {
                    return '목표 금액을 입력해주세요';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return '유효한 금액을 입력해주세요';
                  }
                  return null;
                }, (value) {
                  _targetAmount = int.parse(value!);
                }, keyboardType: TextInputType.number),
                SizedBox(height: 32),
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String? Function(String?) validator, void Function(String?) onSaved, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: '$label 입력',
            hintStyle: TextStyle(color: _subTextColor),
            filled: true,
            fillColor: _cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
          ),
          style: TextStyle(fontSize: 16, color: _textColor),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _createFund();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text('펀드 생성하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}