import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/models/loan/loan.dart';
import '/widgets/asset/assetloan/RecommendedLoanCard.dart';
import '/widgets/asset/assetloan/LoanComparisonCard.dart';

class LoanRecommendationPage extends StatefulWidget {
  @override
  _LoanRecommendationPageState createState() => _LoanRecommendationPageState();
}

class _LoanRecommendationPageState extends State<LoanRecommendationPage> {
  late Future<List<Loan>> futureRecommendedLoans;

  @override
  void initState() {
    super.initState();
    futureRecommendedLoans = ApiService().fetchRecommendedLoans();
  }

  @override
  Widget build(BuildContext context) {
    print('recomand page build');
    return FutureBuilder<List<Loan>>(
      future: futureRecommendedLoans,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final loans = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('추천 대출 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  RecommendedLoanCard(loan: loans.first),
                  SizedBox(height: 24),
                  Text('대출 순위 보기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...loans.map((loan) => LoanComparisonCard(loan: loan)).toList(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Text('대출 조회하기'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/loading');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('No recommendations available'));
        }
      },
    );
  }
}