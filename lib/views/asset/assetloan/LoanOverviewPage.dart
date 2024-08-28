import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import '../../../widgets/asset/assetloan/LoanBalanceCard.dart';
import '../../../widgets/asset/assetloan/CardSelectionWidget.dart';

class LoanOverviewPage extends StatefulWidget {
  @override
  _LoanOverviewPageState createState() => _LoanOverviewPageState();
}

class _LoanOverviewPageState extends State<LoanOverviewPage> {
  late Future<int> sumRemainedAmount;

  @override
  void initState() {
    super.initState();
    sumRemainedAmount = ApiService().fetchSumRemainAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('부부를 위한 상품(평생워치)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<int>(
            future: sumRemainedAmount,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('에러가 발생했습니다: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('대출 정보가 없습니다.'));
              }

              int totalLoanAmount = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  CardSelectionWidget(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('내 대출 상황 보러가기'),
                    onPressed: () {
                      // 내 대출 상황 페이지로 이동하는 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      // minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  LoanBalanceCard(balance: totalLoanAmount),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}