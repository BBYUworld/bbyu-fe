import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';

class CoupleAssetsScreen extends StatelessWidget {
  final CoupleResponseDto coupleDto;

  CoupleAssetsScreen({required this.coupleDto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${coupleDto.nickname}의 총 자산'),
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoupleInfoCard(),
              SizedBox(height: 16),
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
      color: Colors.pink[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(coupleDto.nickname, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupleDto.user1Name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('1,234,567원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(coupleDto.user2Name, style: TextStyle(fontWeight: FontWeight.bold)),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetSection(String title, int totalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${totalAmount.toString()}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        _buildAssetItem('신한은행', '114-12-111111', 10000),
        _buildAssetItem('신한은행', '114-12-111111', 10000),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAssetItem(String bankName, String accountNumber, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bankName),
            Text(accountNumber, style: TextStyle(color: Colors.grey)),
          ],
        ),
        Text('${amount.toString()}원'),
      ],
    );
  }
}