import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdditionalInfoScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;

  AdditionalInfoScreen({required this.onComplete});

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  String _gender = 'male';
  String _region = '서울';
  String _occupation = '공무원';
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _desiredSpendingController = TextEditingController();
  final List<String> _regions = ['서울', '경기', '인천', '지방대도시', '기타지방'];
  final List<String> _occupations = ['공무원', '대기업직원', '중소기업직원', '자영업자', '프리랜서', '무직', '은퇴자'];

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _textColor = Color(0xFF191F28);

  void _submitAdditionalInfo() {
    if (_ageController.text.isEmpty ||
        _salaryController.text.isEmpty ||
        _desiredSpendingController.text.isEmpty) {
      _showSnackBar('모든 필드를 입력해주세요.');
      return;
    }

    widget.onComplete({
      'gender': _gender,
      'age': int.parse(_ageController.text),
      'salary': int.parse(_salaryController.text),
      'desiredSpending': int.parse(_desiredSpendingController.text),
      'region': _region,
      'occupation': _occupation,
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        title: Text('추가 정보', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenderSelection(),
            SizedBox(height: 24),
            _buildInputField('나이', _ageController, TextInputType.number),
            SizedBox(height: 24),
            _buildInputField('연봉 (만원)', _salaryController, TextInputType.number),
            SizedBox(height: 24),
            _buildInputField('희망하는 한달 소비 금액 (만원)', _desiredSpendingController, TextInputType.number),
            SizedBox(height: 24),
            _buildDropdownField('지역', _region, _regions),
            SizedBox(height: 24),
            _buildDropdownField('직업', _occupation, _occupations),
            SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 12),
        Row(
          children: [
            _buildGenderOption('남성', 'male'),
            SizedBox(width: 12),
            _buildGenderOption('여성', 'female'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String value) {
    bool isSelected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _gender = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? _primaryColor : Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : _textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (label == '지역') {
                _region = newValue!;
              } else if (label == '직업') {
                _occupation = newValue!;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitAdditionalInfo,
        child: Text('완료', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}