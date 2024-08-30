import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/loan/CoupleLoanRecommendation.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:intl/intl.dart';

import '../../models/loan/MoneyDto.dart';

class CoupleLoanRecommendationPage extends StatefulWidget {
  @override
  _CoupleLoanRecommendationPageState createState() => _CoupleLoanRecommendationPageState();
}

class _CoupleLoanRecommendationPageState extends State<CoupleLoanRecommendationPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _moneyController = TextEditingController();
  CoupleLoanRecommendation? _recommendation;
  bool _isLoading = false;

  // Toss-style colors
  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('커플 대출 추천', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMoneyInput(),
                SizedBox(height: 24),
                if (_isLoading)
                  _buildLoadingState()
                else if (_recommendation != null)
                  _buildRecommendationResult()
                else
                  _buildInitialState(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('대출 금액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
          SizedBox(height: 12),
          TextField(
            controller: _moneyController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor),
            decoration: InputDecoration(
              hintText: '0',
              suffixText: '원',
              suffixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _subTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: _backgroundColor,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _fetchRecommendation,
              child: Text('추천받기', style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryColor)),
          SizedBox(height: 24),
          Text('최적의 대출 상품을 찾고 있어요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
          SizedBox(height: 8),
          Text('잠시만 기다려주세요', style: TextStyle(fontSize: 16, color: _subTextColor)),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: _primaryColor),
          SizedBox(height: 24),
          Text('대출 금액을 입력하고', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
          Text('추천받기 버튼을 눌러주세요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
        ],
      ),
    );
  }

  Widget _buildRecommendationResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('추천 결과', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 16),
        _buildUserInfo(),
        SizedBox(height: 24),
        ..._recommendation!.coupleLoanRecommends.asMap().entries.map(
                (entry) => _buildRecommendCard(entry.value, entry.key + 1)
        ).toList(),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildUserInfoColumn(_recommendation!.user1Name, _recommendation!.user1Gender),
          _buildUserInfoColumn(_recommendation!.user2Name, _recommendation!.user2Gender),
        ],
      ),
    );
  }

  Widget _buildUserInfoColumn(String name, String gender) {
    return Column(
      children: [
        Icon(
          gender == 'MALE' ? Icons.face : Icons.face_3,
          size: 48,
          color: _primaryColor,
        ),
        SizedBox(height: 8),
        Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
      ],
    );
  }

  Widget _buildRecommendCard(CoupleLoanRecommend recommend, int rank) {
    final formatter = NumberFormat('#,###');
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$rank위', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '총 ${formatter.format(recommend.totalPayment)}원',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildLoanInfo(recommend.recommendUser1, _recommendation!.user1Name),
          Divider(height: 32, color: _backgroundColor),
          _buildLoanInfo(recommend.recommendUser2, _recommendation!.user2Name),
        ],
      ),
    );
  }

  Widget _buildLoanInfo(LoanRecommend loan, String userName) {
    final formatter = NumberFormat('#,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$userName의 대출', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 8),
        _buildLoanInfoRow('은행', loan.bankName),
        _buildLoanInfoRow('상품명', loan.loanName),
        _buildLoanInfoRow('대출한도', '${formatter.format(loan.loanLimit)}원'),
        _buildLoanInfoRow('금리', '${loan.interestRate.toStringAsFixed(2)}%'),
        _buildLoanInfoRow('대출기간', '${loan.loanTermMonths}개월'),
        _buildLoanInfoRow('신용점수 요구사항', '${loan.creditScoreRequirement}'),
      ],
    );
  }

  Widget _buildLoanInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: _subTextColor)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
        ],
      ),
    );
  }

  void _fetchRecommendation() async {
    if (_moneyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('대출 금액을 입력해주세요.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final moneyDto = MoneyDto(money: int.parse(_moneyController.text));
      final recommendation = await _apiService.fetchCoupleRecommendedLoans(moneyDto);
      setState(() {
        _recommendation = recommendation;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('추천을 가져오는 중 오류가 발생했습니다.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}