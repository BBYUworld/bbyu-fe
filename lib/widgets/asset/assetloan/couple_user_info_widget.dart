import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/credit_score_page.dart';

class CoupleUserInfoCard extends StatelessWidget {
  final String coupleName;
  final String user1Name;
  final String user2Name;
  final String user1RatingName;
  final String user2RatingName;

  CoupleUserInfoCard({
    required this.coupleName,
    required this.user1Name,
    required this.user2Name,
    required this.user1RatingName,
    required this.user2RatingName,
  });

  String getRatingMessage(String ratingName) {
    switch (ratingName) {
      case 'A':
        return '매우 우수합니다! 😄';
      case 'B':
        return '우수합니다 😊';
      case 'C':
        return '보통입니다 😉';
      case 'D':
        return '신용 등급 관리가 필요합니다 🙂';
      case 'E':
        return '신용 등급 관리가 필수적입니다 😐';
      default:
        return '정보가 없습니다 😎';
    }
  }

  Widget _buildUserInfo(BuildContext context, String name, String ratingName) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              child: Text(name[0]),
              radius: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name님의 금융정보',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '마지막 업데이트: 2024.02.16',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '신용평점',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${getRatingMessage(ratingName)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('신용등급 진단'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreditScorePage()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$coupleName의 금융정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildUserInfo(context, user1Name, user1RatingName),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            _buildUserInfo(context, user2Name, user2RatingName),
          ],
        ),
      ),
    );
  }
}