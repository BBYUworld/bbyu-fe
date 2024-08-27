import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanInfoPage.dart'; // MyLoanInfoPage를 import

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'XXX 부부',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildCoupleCard(),
              SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard('뷰 펀딩', Icons.search, () {}),
                    _buildMenuCard('뷰 상품 추천', Icons.message, () {}),
                    _buildMenuCard('가계부', Icons.attach_money, () {}),
                    _buildMenuCard('뷰 자산 리포트', Icons.description, () {}),
                    _buildMenuCard('병주\'s 대출 페이지', Icons.description, () {
                      Navigator.pushNamed(
                        context,
                        '/loan',
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoupleCard() {
    return Card(
      color: Colors.pink[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('김싸피', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('1,234,567원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('박싸피', style: TextStyle(fontWeight: FontWeight.bold)),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}