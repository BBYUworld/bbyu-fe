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

  final Color _primaryColor = Color(0xFFF5E7E0);
  final Color _textColor = Color(0xFF4A4A4A);

  void _submitAdditionalInfo() {
    if (_ageController.text.isEmpty ||
        _salaryController.text.isEmpty ||
        _desiredSpendingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('입력 오류', style: TextStyle(color: _textColor)),
            content: Text('모든 필드를 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인', style: TextStyle(color: _textColor)),
              ),
            ],
          );
        },
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('추가 정보', style: TextStyle(color: _textColor)),
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('기본 정보'),
            SizedBox(height: 20),
            _buildGenderSelection(),
            SizedBox(height: 20),
            _buildInputField('나이', _ageController, TextInputType.number),
            SizedBox(height: 20),
            _buildInputField('연봉 (만원)', _salaryController, TextInputType.number),
            SizedBox(height: 20),
            _buildInputField('희망하는 한달 소비 금액 (만원)', _desiredSpendingController, TextInputType.number),
            SizedBox(height: 20),
            _buildSectionTitle('추가 정보'),
            SizedBox(height: 20),
            _buildDropdownField('지역', _region, _regions),
            SizedBox(height: 20),
            _buildDropdownField('직업', _occupation, _occupations),
            SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
        SizedBox(height: 10),
        Row(
          children: [
            _buildGenderOption('남성', 'male'),
            SizedBox(width: 20),
            _buildGenderOption('여성', 'female'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String value) {
    bool isSelected = _gender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,
          border: Border.all(color: isSelected ? _primaryColor : Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _textColor : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _primaryColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
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
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _primaryColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
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
        child: Text('다음', style: TextStyle(fontSize: 16, color: _textColor)),
        style: ElevatedButton.styleFrom(
          foregroundColor: _textColor,
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}