import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TokenStorage _tokenStorage = TokenStorage();
  CoupleResponse? _coupleResponse;

  String _goal = '';
  int _targetAmount = 0;
  bool _isLoading = true;

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    _fetchCoupleInfo();
    _targetAmountController.addListener(_formatTargetAmount);
  }

  @override
  void dispose() {
    _goalController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _formatTargetAmount() {
    String text = _targetAmountController.text.replaceAll(',', '');
    if (text.isEmpty) return;

    int? value = int.tryParse(text);
    if (value == null) return;

    String formatted = _numberFormat.format(value);
    if (formatted != _targetAmountController.text) {
      _targetAmountController.value = TextEditingController.fromValue(TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      )).value;
    }
  }

  Future<void> _fetchCoupleInfo() async {
    print('Fetching couple info...');
    final url = Uri.parse('http://10.0.2.2:8080/api/couple');
    final accessToken = await _tokenStorage.getAccessToken();
    print('Access Token: $accessToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _coupleResponse = CoupleResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
          _isLoading = false;
        });
        print('Couple Response: $_coupleResponse');
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
    print('=============================0000000000000000==========================');
    if (_coupleResponse == null) {
      print('Error: _coupleResponse is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('커플 정보를 불러오는데 실패했습니다. 다시 시도해주세요.')),
      );
      return;
    }

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
                _buildInputField(
                  '펀드 목표',
                  _goalController,
                  '예: 신혼여행 자금',
                      (value) {
                    if (value == null || value.isEmpty) {
                      return '펀드 목표를 입력해주세요';
                    }
                    return null;
                  },
                      (value) {
                    _goal = value!;
                  },
                ),
                SizedBox(height: 24),
                _buildInputField(
                  '목표 금액',
                  _targetAmountController,
                  '0',
                      (value) {
                    if (value == null || value.isEmpty) {
                      return '목표 금액을 입력해주세요';
                    }
                    if (int.tryParse(value.replaceAll(',', '')) == null || int.parse(value.replaceAll(',', '')) <= 0) {
                      return '유효한 금액을 입력해주세요';
                    }
                    return null;
                  },
                      (value) {
                    _targetAmount = int.parse(value!.replaceAll(',', ''));
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffix: Text('원', style: TextStyle(color: _subTextColor)),
                ),
                SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller,
      String hint,
      String? Function(String?) validator,
      void Function(String?) onSaved, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        Widget? suffix,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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
            suffixIcon: suffix != null ? Padding(
              padding: EdgeInsets.only(right: 15),
              child: suffix,
            ) : null,
          ),
          style: TextStyle(fontSize: 16, color: _textColor),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await _createFund();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text('펀드 생성하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}