import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/loan/MoneyDto.dart';

class LoanCard extends StatefulWidget {
  final FundOverview fundOverview;

  LoanCard({required this.fundOverview});

  @override
  _LoanCardState createState() => _LoanCardState();
}

class _LoanCardState extends State<LoanCard> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToLoading(context),
      child: FutureBuilder<int>(
        future: _apiService.fetchSumRemainAmount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard();
          } else if (snapshot.hasError) {
            return _buildErrorCard();
          } else if (snapshot.hasData) {
            return _buildLoanCard(snapshot.data!);
          } else {
            return _buildErrorCard();
          }
        },
      ),
    );
  }

  Widget _buildLoanCard(int loanAmount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '현재 대출',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B)),
                ),
                Icon(Icons.account_balance_wallet, color: Color(0xFFFF6B6B), size: 28),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '대출 금액: ${_formatCurrency(loanAmount)}',
              style: TextStyle(fontSize: 18, color: Color(0xFFFF6B6B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('대출 정보를 불러오는데 실패했습니다.', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }

  void _navigateToLoading(BuildContext context) async {
    int remainingAmount = widget.fundOverview.targetAmount - widget.fundOverview.currentAmount;
    MoneyDto moneyDto = MoneyDto(money: remainingAmount);

    try {
      await Navigator.pushNamed(
        context,
        '/loading',
        arguments: {
          'moneyDto': moneyDto,
          'fetchRecommendation': () => _apiService.fetchCoupleRecommendedLoans(moneyDto),
        },
      );
    } catch (e) {
      print('Error navigating to loading page: $e');
      // 에러 처리 로직 추가
    }
  }
}