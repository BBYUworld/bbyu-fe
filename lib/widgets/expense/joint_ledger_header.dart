import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/models/expense/couple_expense_model.dart';

class JointLedgerHeader extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final int displayedYear;
  final int displayedMonth;
  final void Function(int increment) onMonthChanged;

  const JointLedgerHeader({
    Key? key,
    required this.coupleExpense,
    required this.displayedYear,
    required this.displayedMonth,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  _JointLedgerHeaderState createState() => _JointLedgerHeaderState();
}

class _JointLedgerHeaderState extends State<JointLedgerHeader> {
  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isNextMonthDisabled = widget.displayedYear > now.year || (widget.displayedYear == now.year && widget.displayedMonth >= now.month);

    return Column(
      children: [
        _buildMonthSelector(isNextMonthDisabled),
        _buildCarousel(isNextMonthDisabled),
        _buildTotalAmountInfo(),
        _buildCategoryInfo(),
      ],
    );
  }

  Widget _buildMonthSelector(bool isNextMonthDisabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => widget.onMonthChanged(-1),
        ),
        Text(
          '${widget.displayedYear}년 ${widget.displayedMonth}월',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: isNextMonthDisabled ? null : () => widget.onMonthChanged(1),
          color: isNextMonthDisabled ? Colors.grey : Colors.black,
        ),
      ],
    );
  }

  Widget _buildTotalAmountInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(Icons.attach_money, color: Colors.green),
          SizedBox(width: 8),
          Text(
            '총 지출 금액  ${_formatCurrency(widget.coupleExpense?.totalAmount ?? 0)}원',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 13.0),
      child: Row(
        children: [
          getCategoryIcon(widget.coupleExpense?.category ?? ''),
          SizedBox(width: 8),
          Text(
            '${widget.displayedYear}년 ${widget.displayedMonth}월은 ${widget.coupleExpense?.category ?? '카테고리 없음'}에 많이 썼어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(bool isNextMonthDisabled) {
    return Container(
      height: 130,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        onPageChanged: (index) {},
        children: [
          _buildComparisonCard(),
          _buildSavingsCard(),
        ],
      ),
    );
  }

  Widget _buildComparisonCard() {
    int expenseDifference = widget.coupleExpense?.totalAmountFromLastMonth ?? 0;
    String expenseComparisonMessage;
    Color comparisonColor;
    IconData comparisonIcon;

    if (expenseDifference > 0) {
      expenseComparisonMessage = '${_formatCurrency(expenseDifference.abs())}원 덜 썼어요.';
      comparisonColor = Colors.green;
      comparisonIcon = Icons.trending_down;
    } else {
      expenseComparisonMessage = '${_formatCurrency(expenseDifference.abs())}원 더 썼어요.';
      comparisonColor = Colors.red;
      comparisonIcon = Icons.trending_up;
    }

    return _buildCard(
      content: Row(
        children: [
          Icon(comparisonIcon, size: 50, color: comparisonColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '지난달보다',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  expenseComparisonMessage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: comparisonColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard() {
    String savingsMessage;
    IconData savingsIcon;
    Color iconColor;
    Color textColor;

    if ((widget.coupleExpense?.amountDifference ?? 0) > 0) {
      savingsMessage = '잘 절약하고 계시네요! 오늘은 배우자와 함께 맛있는 외식을 해보시는건 어떤가요?';
      savingsIcon = Icons.thumb_up;
      iconColor = Colors.green;
      textColor = Colors.black54;
    } else {
      savingsMessage = '절약이 필요할 거 같아요! 오늘은 배우자와 함께 맛있는 집밥을 만들어 먹어봐요.';
      savingsIcon = Icons.warning;
      iconColor = Colors.red;
      textColor = Colors.black54;
    }

    return _buildCard(
      content: Row(
        children: [
          Icon(savingsIcon, size: 50, color: iconColor),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              savingsMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget content}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.pink[50], // 연한 핑크색 배경
      ),
      child: Card(
        color: Colors.pink[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
    );
  }

  static Icon getCategoryIcon(String category) {
    switch (category) {
      case '교육':
        return Icon(Icons.school, color: Colors.blueAccent);
      case '교통_자동차':
        return Icon(Icons.directions_car, color: Colors.orangeAccent);
      case '기타소비':
        return Icon(Icons.shopping_basket, color: Colors.greenAccent);
      case '대형마트':
        return Icon(Icons.store, color: Colors.deepPurpleAccent);
      case '미용':
        return Icon(Icons.brush, color: Colors.pinkAccent);
      case '배달':
        return Icon(Icons.delivery_dining, color: Colors.tealAccent);
      case '보험':
        return Icon(Icons.security, color: Colors.brown);
      case '생필품':
        return Icon(Icons.local_grocery_store, color: Colors.blue);
      case '생활서비스':
        return Icon(Icons.handyman, color: Colors.indigo);
      case '세금_공과금':
        return Icon(Icons.receipt_long, color: Colors.redAccent);
      case '쇼핑몰':
        return Icon(Icons.shopping_cart, color: Colors.purple);
      case '여행_숙박':
        return Icon(Icons.hotel, color: Colors.cyanAccent);
      case '외식':
        return Icon(Icons.restaurant, color: Colors.deepOrange);
      case '의료_건강':
        return Icon(Icons.local_hospital, color: Colors.red);
      case '주류_펍':
        return Icon(Icons.local_bar, color: Colors.amber);
      case '취미_여가':
        return Icon(Icons.music_note, color: Colors.green);
      case '카페':
        return Icon(Icons.local_cafe, color: Colors.brown);
      case '통신':
        return Icon(Icons.phone, color: Colors.lightBlue);
      case '편의점':
        return Icon(Icons.local_convenience_store, color: Colors.yellow);
      default:
        return Icon(Icons.category, color: Colors.grey);
    }
  }
}