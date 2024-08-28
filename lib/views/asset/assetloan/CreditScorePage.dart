// views/loan/CreditScorePage.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CreditScorePage extends StatelessWidget {
  final int creditScore;
  final String creditGrade;

  CreditScorePage({this.creditScore = 750, this.creditGrade = 'A'});  // 예시 데이터

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신용등급 진단'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditScoreCard(score: creditScore, grade: creditGrade),
              SizedBox(height: 20),
              CreditScoreChart(score: creditScore),
              SizedBox(height: 20),
              CreditScoreTips(),
            ],
          ),
        ),
      ),
    );
  }
}

class CreditScoreCard extends StatelessWidget {
  final int score;
  final String grade;

  CreditScoreCard({required this.score, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('현재 신용 점수', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('$score', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 10),
            Text('신용 등급: $grade', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class CreditScoreChart extends StatelessWidget {
  final int score;

  CreditScoreChart({required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('신용 점수 변화', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 5,
                  minY: 300,
                  maxY: 900,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 650),
                        FlSpot(1, 680),
                        FlSpot(2, 700),
                        FlSpot(3, 690),
                        FlSpot(4, 720),
                        FlSpot(5, score.toDouble()),
                      ],
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditScoreTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('신용 점수 개선 팁', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('정기적으로 신용 보고서를 확인하세요'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('신용카드 사용 한도를 30% 이하로 유지하세요'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('모든 청구서를 제때 납부하세요'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('다양한 유형의 신용을 사용하세요'),
            ),
          ],
        ),
      ),
    );
  }
}