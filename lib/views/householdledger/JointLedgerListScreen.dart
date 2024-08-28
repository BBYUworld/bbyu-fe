import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';
import 'package:intl/intl.dart';

class JointLedgerListScreen extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final Future<void> Function(int year, int month) onRefresh;

  JointLedgerListScreen({
    required this.coupleExpense,
    required this.onRefresh,
  });

  @override
  _JointLedgerListScreenState createState() => _JointLedgerListScreenState();
}

class _JointLedgerListScreenState extends State<JointLedgerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final now = DateTime.now();
          await widget.onRefresh(now.year, now.month);
        },
        child: Column(
          children: [
            _buildAccountInfo(),
            Expanded(
              child: _buildGroupedExpenseList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
    // 목표와 실제 지출 차이에 따른 메시지 생성
    String differenceMessage;
    Color differenceColor;
    if (widget.coupleExpense!.amountDifference > 0) {
      differenceMessage = '목표 소비량보다 ${widget.coupleExpense!.amountDifference}원 아끼고 있어요!';
      differenceColor = Colors.green;
    } else if (widget.coupleExpense!.amountDifference < 0) {
      differenceMessage = '목표 소비량보다 ${widget.coupleExpense!.amountDifference.abs()}원 더 썼어요!';
      differenceColor = Colors.red;
    } else {
      differenceMessage = '목표 소비량과 일치합니다!';
      differenceColor = Colors.blue;
    }

    // 저번달과의 비교를 위한 가상의 저번달 지출 금액
    // 실제로는 이전 달 데이터를 받아와야 합니다.
    int previousMonthExpense = 150000; // 예를 들어
    int expenseDifference = previousMonthExpense - widget.coupleExpense!.totalAmount;
    String expenseComparisonMessage;
    if (expenseDifference > 0) {
      expenseComparisonMessage = '저번달보다 ${expenseDifference}원 덜 썼어요.';
    } else if (expenseDifference < 0) {
      expenseComparisonMessage = '저번달보다 ${expenseDifference.abs()}원 더 썼어요.';
    } else {
      expenseComparisonMessage = '저번달과 동일한 금액을 썼어요!';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 월별 지출 금액
          Text(
            '${DateFormat('MMMM').format(DateTime.now())}월의 지출 금액',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          // 이번 달 지출 금액
          Text(
            '${widget.coupleExpense?.totalAmount ?? 0}원',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          // 목표 소비량과의 비교 메시지
          Text(
            differenceMessage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: differenceColor,
            ),
          ),
          SizedBox(height: 8),
          // 저번달과의 지출 비교 메시지
          Text(
            expenseComparisonMessage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedExpenseList() {
    if (widget.coupleExpense == null || widget.coupleExpense!.dayExpenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('현재 지출 내역이 없습니다.'),
        ),
      );
    }

    final groupedExpenses = _groupExpensesByDate(widget.coupleExpense!.dayExpenses);
    final sortedDates = groupedExpenses.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final expenses = groupedExpenses[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 날짜별 지출 내역
            ...expenses.map((expense) {
              return ListTile(
                leading: _getCategoryIcon(expense.category),
                title: Text(
                  expense.category,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // 카테고리 텍스트 크기 키움
                  ),
                ),
                subtitle: Text(
                  '${expense.place} - ${expense.memo}\n${expense.name}',
                  style: TextStyle(fontSize: 14), // 서브 타이틀 텍스트 크기
                ),
                trailing: Text(
                  '-${expense.amount}원',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // 금액 텍스트 크기 키움
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isThreeLine: true,
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Map<String, List<DailyDetailExpense>> _groupExpensesByDate(List<DailyDetailExpense> expenses) {
    final groupedExpenses = <String, List<DailyDetailExpense>>{};
    for (var expense in expenses) {
      final date = DateFormat('yyyy-MM-dd').format(expense.date);
      if (groupedExpenses.containsKey(date)) {
        groupedExpenses[date]!.add(expense);
      } else {
        groupedExpenses[date] = [expense];
      }
    }
    return groupedExpenses;
  }

  Icon _getCategoryIcon(String category) {
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
