import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/models/loan/loan.dart';
import '/widgets/asset/assetloan/RecommendedLoanCard.dart';
import '/widgets/asset/assetloan/loan_comparison_widget.dart';
import '/widgets/loan/loan_amount_widget.dart';

class LoanRecommendationPage extends StatefulWidget {
  @override
  _LoanRecommendationPageState createState() => _LoanRecommendationPageState();
}

class _LoanRecommendationPageState extends State<LoanRecommendationPage> {
  late Future<List<Loan>> futureRecommendedLoans;
  final TextEditingController _loanAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureRecommendedLoans = ApiService().fetchRecommendedLoans();
  }

  void _onSubmitLoanAmount() {
    String amount = _loanAmountController.text;
    if (amount.isNotEmpty) {
      Navigator.pushNamed(context, '/loading', arguments: amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('대출 금액을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('recommend page build');
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
                  LoanAmountInputWidget(
                    controller: _loanAmountController,
                    onSubmit: _onSubmitLoanAmount,
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

  @override
  void dispose() {
    _loanAmountController.dispose();
    super.dispose();
  }
}