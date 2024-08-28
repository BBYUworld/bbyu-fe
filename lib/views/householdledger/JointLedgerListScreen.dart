import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';
import 'package:intl/intl.dart';

class JointLedgerListScreen extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final Future<void> Function(int year, int month) onRefresh;
  final int currentYear;
  final int currentMonth;
  final void Function(int year, int month) onMonthChanged;

  JointLedgerListScreen({
    required this.coupleExpense,
    required this.onRefresh,
    required this.currentYear,
    required this.currentMonth,
    required this.onMonthChanged,
  });

  @override
  _JointLedgerListScreenState createState() => _JointLedgerListScreenState();
}

class _JointLedgerListScreenState extends State<JointLedgerListScreen> {
  late int displayedYear;
  late int displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedYear = widget.currentYear;
    displayedMonth = widget.currentMonth;
  }

  void _changeMonth(int increment) {
    setState(() {
      displayedMonth += increment;
      if (displayedMonth > 12) {
        displayedMonth = 1;
        displayedYear++;
      } else if (displayedMonth < 1) {
        displayedMonth = 12;
        displayedYear--;
      }
      widget.onMonthChanged(displayedYear, displayedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.onRefresh(displayedYear, displayedMonth);
        },
        child: Column(
          children: [
            _buildCarousel(),
            Expanded(
              child: _buildGroupedExpenseList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              '${DateFormat('MMMM').format(DateTime(displayedYear, displayedMonth))}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
        Container(
          height: 150,
          child: PageView(
            onPageChanged: (index) {},
            children: [
              _buildComparisonCard(),
              _buildSavingsCard(),
              _buildCategoryCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonCard() {
    int expenseDifference = widget.coupleExpense?.totalAmountFromLastMonth ?? 0;
    String expenseComparisonMessage;
    Color comparisonColor;
    if (expenseDifference > 0) {
      expenseComparisonMessage = '저번달보다 ${expenseDifference.abs()}원 덜 썼어요.';
      comparisonColor = Colors.green;
    } else {
      expenseComparisonMessage = '저번달보다 ${expenseDifference.abs()}원 더 썼어요.';
      comparisonColor = Colors.red;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: comparisonColor,
              ),
            ),
            Expanded(child: SizedBox()), // Spacer 대신 Expanded 사용
            Text(
              '더보기 >',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsCard() {
    String savingsMessage;
    if ((widget.coupleExpense?.amountDifference ?? 0) > 0) {
      savingsMessage = '잘 절약하고 계시네요! 오늘은 배우자와 함께 맛있는 외식을 해보시는건 어떤가요?';
    } else {
      savingsMessage = '절약이 필요할 거 같아요! 오늘은 배우자와 함께 맛있는 집밥을 만들어 먹어봐요.';
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              savingsMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: (widget.coupleExpense?.amountDifference ?? 0) > 0 ? Colors.green : Colors.red,
              ),
            ),
            Expanded(child: SizedBox()), // Spacer 대신 Expanded 사용
            Text(
              '더보기 >',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이번 달 최다 소비',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _getCategoryIcon(widget.coupleExpense?.category ?? ''),
                SizedBox(width: 8),
                Text(
                  '${widget.coupleExpense?.category ?? '카테고리 없음'}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()), // Spacer 대신 Expanded 사용
            Text(
              '더보기 >',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
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
