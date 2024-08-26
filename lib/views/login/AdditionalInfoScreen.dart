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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _desiredSpendingController = TextEditingController();

  void _submitAdditionalInfo() {
    if (_ageController.text.isEmpty ||
        _salaryController.text.isEmpty ||
        _desiredSpendingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('입력 오류'),
            content: Text('모든 필드를 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('성별'),
          Row(
            children: [
              Radio(
                value: 'male',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
              Text('남성'),
              Radio(
                value: 'female',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
              Text('여성'),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: '나이'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _salaryController,
            decoration: InputDecoration(labelText: '연봉 (만원)'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _desiredSpendingController,
            decoration: InputDecoration(labelText: '희망하는 한달 소비 금액 (만원)'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitAdditionalInfo,
            child: Text('다음'),
          ),
        ],
      ),
    );
  }
}