import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:intl/intl.dart';

class CoupleAssetsScreen extends StatelessWidget {
  final CoupleResponseDto coupleDto;

  CoupleAssetsScreen({required this.coupleDto});

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('${coupleDto.nickname}의 총 자산',
            style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoupleInfoCard(),
              SizedBox(height: 24),
              _buildAssetSection('계좌', 20000),
              _buildAssetSection('예금/적금', 20000),
              _buildAssetSection('주식', 20000),
              _buildAssetSection('대출', 20000),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoupleInfoCard() {
    return Card(
      color: _cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _primaryColor.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(coupleDto.nickname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUserInfo(coupleDto.user1Name, 1234567),
                _buildUserInfo(coupleDto.user2Name, 987654),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 4),
        Text('${_formatCurrency(amount)}원',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor)),
      ],
    );
  }

  Widget _buildAssetSection(String title, int totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
              Text('${_formatCurrency(totalAmount)}원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor)),
            ],
          ),
        ),
        _buildAssetItem('신한은행', '114-12-111111', 10000),
        _buildAssetItem('신한은행', '114-12-111111', 10000),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAssetItem(String bankName, String accountNumber, int amount) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bankName, style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
              SizedBox(height: 4),
              Text(accountNumber, style: TextStyle(color: _subTextColor, fontSize: 12)),
            ],
          ),
          Text('${_formatCurrency(amount)}원',
              style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
        ],
      ),
    );
  }
}