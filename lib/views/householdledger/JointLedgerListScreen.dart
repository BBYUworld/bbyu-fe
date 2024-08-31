import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/expense/couple_expense_model.dart';
import 'package:gagyebbyu_fe/models/expense/expense_category.dart';
import 'package:gagyebbyu_fe/widgets/expense/joint_ledger_header.dart';
import 'package:intl/intl.dart';
import '../../services/ledger_api_service.dart';
import 'edit_expense_modal.dart'; // 새로 만든 모달 파일 임포트

class JointLedgerListScreen extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final Future<void> Function(int year, int month) onRefresh;
  final int currentYear;
  final int currentMonth;
  final void Function(int year, int month) onMonthChanged;
  final LedgerApiService apiService;  // apiService 추가

  JointLedgerListScreen({
    required this.coupleExpense,
    required this.onRefresh,
    required this.currentYear,
    required this.currentMonth,
    required this.onMonthChanged,
    required this.apiService,  // apiService 추가
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

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(amount);
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
            JointLedgerHeader(
              coupleExpense: widget.coupleExpense,
              displayedYear: displayedYear,
              displayedMonth: displayedMonth,
              onMonthChanged: _changeMonth,
            ),
            Expanded(
              child: _buildGroupedExpenseList(),
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
                  categoryToString(categoryFromString(expense.category)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // 카테고리 텍스트 크기 키움
                  ),
                ),
                subtitle: Text(
                  '${expense.name}\n메모 - ${expense.memo}',
                  style: TextStyle(fontSize: 14), // 서브 타이틀 텍스트 크기
                ),
                trailing: Text(
                  '-${_formatCurrency(expense.amount)}원',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // 금액 텍스트 크기 키움
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isThreeLine: true,
                onTap: () {
                  _editExpense(expense); // 항목 클릭 시 수정 모달 열기
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  void _editExpense(DailyDetailExpense expense) async {
    final updatedExpense = await showDialog<DailyDetailExpense>(
      context: context,
      builder: (BuildContext context) {
        return EditExpenseModal(
          expense: expense,
          apiService: widget.apiService,  // apiService 전달
        );
      },
    );

    if (updatedExpense != null) {
      setState(() {
        final index = widget.coupleExpense!.dayExpenses.indexWhere((e) => e.expenseId == updatedExpense.expenseId);
        if (index != -1) {
          widget.coupleExpense!.dayExpenses[index] = updatedExpense;
        }
      });
    }
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
