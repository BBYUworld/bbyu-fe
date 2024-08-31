import 'package:flutter/material.dart';
import '../../models/expense/couple_expense_model.dart';
import '../../services/ledger_api_service.dart';

class DailyExpenseDetailModal extends StatefulWidget {
  final DateTime date;
  final CoupleExpense coupleExpense;
  final LedgerApiService apiService;

  DailyExpenseDetailModal({
    required this.date,
    required this.coupleExpense,
    required this.apiService,
  });

  @override
  _DailyExpenseDetailModalState createState() => _DailyExpenseDetailModalState();
}

class _DailyExpenseDetailModalState extends State<DailyExpenseDetailModal> {
  late List<DailyDetailExpense> filteredExpenses;

  @override
  void initState() {
    super.initState();
    filteredExpenses = widget.coupleExpense.dayExpenses
        .where((expense) => isSameDay(expense.date, widget.date))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    print("Building DailyExpenseDetailModal");

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.date.month}월 ${widget.date.day}일 ${_getWeekdayName(widget.date.weekday)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '총 ${filteredExpenses.length}건 -${_calculateTotalExpense(filteredExpenses)}원',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];
                print("Expense memo: ${expense.memo}"); // 각 항목의 메모 출력

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: _getCategoryIcon(expense.category ?? '기타소비'),
                          ),
                          SizedBox(height: 4),
                          Text(
                            expense.name ?? '알 수 없음',
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    expense.category ?? '카테고리 없음',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '-${expense.amount.abs()}원',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      expense.memo ?? '설명 없음',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 16, color: Colors.grey),
                                    onPressed: () {
                                      _editMemo(context, expense, index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  int _calculateTotalExpense(List<DailyDetailExpense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount.abs());
  }

  Future<void> _editMemo(BuildContext context, DailyDetailExpense expense, int index) async {
    TextEditingController controller = TextEditingController(text: expense.memo);

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('메모 수정'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: '메모'),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );

    if (result != null && result != expense.memo) {
      try {
        await widget.apiService.fetchUpdateMemo(expense.expenseId, result);

        print("Updating memo in setState");
        setState(() {
          filteredExpenses[index] = filteredExpenses[index].copyWith(memo: result);
        });

        print("Updated memo: ${filteredExpenses[index].memo}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메모가 업데이트되었습니다.')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메모 업데이트에 실패했습니다.')),
        );
      }
    }
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
