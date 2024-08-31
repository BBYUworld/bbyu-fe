import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/loan/recommend_loan.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/loan_comparison_widget.dart';
import 'package:gagyebbyu_fe/widgets/custom_loading_widget.dart';
import '/models/loan/loan.dart';
import '/services/api_service.dart';
import 'package:intl/intl.dart';

class LoanLoadingScreen extends StatefulWidget {
  @override
  _LoanLoadingScreenState createState() => _LoanLoadingScreenState();
}

class _LoanLoadingScreenState extends State<LoanLoadingScreen> {
  late Future<List<RecommendLoan>> futureRecommendedLoans;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final recommendloans = await ApiService().fetchUserRecommendedLoans();
      setState(() {
        futureRecommendedLoans = Future.value(recommendloans);
        _isDataLoaded = true;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        futureRecommendedLoans = Future.error(e);
        _isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('대출받기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isDataLoaded
          ? FutureBuilder<List<RecommendLoan>>(
        future: futureRecommendedLoans,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildLoanListView(snapshot.data!);
          } else {
            return _buildEmptyView();
          }
        },
      )
          : CustomLoadingWidget(
        loadingTexts: ['쀼AI가 최적의 대출 상품을 찾고 있어요!!', '거의 다 왔어요 쀼AI가 열심히 찾고있어요!!', '조금만 더 기다려주세요!!', '쀼AI가 열심히 찾고있어요!!'],
        imagePath: 'assets/loan_image/loan_info1.png',
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 20),
          Text(
            '오류가 발생했습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Text(
            error,
            style: TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60, color: Color(0xFFFF6B6B)),
          SizedBox(height: 20),
          Text(
            '대출 정보가 없습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanListView(List<RecommendLoan> recommendloans) {
    final numberFormat = NumberFormat('#,###');
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          '대출 순위 보기',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 20),
        ...recommendloans.map((loan) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.loanDto.loanName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('은행: ${loan.loanDto.bankName}'),
                  Text('금리: ${loan.loanDto.interestRate.toStringAsFixed(2)}%'),
                  Text('대출 기간: ${loan.loanDto.loanPeriod}개월'),
                  Text('최소 대출 금액: ${numberFormat.format(loan.loanDto.minBalance)}원'),
                  Text('최대 대출 금액: ${numberFormat.format(loan.loanDto.maxBalance)}원'),
                  Text('상환 방식: ${loan.loanDto.repaymentName}'),
                  SizedBox(height: 8),
                  Text(
                    '추천 점수: ${(loan.pred * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }
}