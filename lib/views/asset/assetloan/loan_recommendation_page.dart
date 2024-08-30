import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/widgets/asset/assetloan/RecommendedLoanCard.dart';
import '/widgets/loan/loan_amount_widget.dart';

class LoanRecommendationPage extends StatefulWidget {
  @override
  _LoanRecommendationPageState createState() => _LoanRecommendationPageState();
}

class _LoanRecommendationPageState extends State<LoanRecommendationPage> {
  final TextEditingController _loanAmountController = TextEditingController();

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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('추천 대출 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                height: 500.0,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 7),
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
              ),
              items: [1,2,3,4,5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return RecommendedLoanCard();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Text(
              '원하시는 대출 금액을 입력해주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            LoanAmountInputWidget(
              controller: _loanAmountController,
              onSubmit: _onSubmitLoanAmount,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('대출 추천 받기'),
              onPressed: _onSubmitLoanAmount,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    super.dispose();
  }
}